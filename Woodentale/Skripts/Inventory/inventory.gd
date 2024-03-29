extends ColorRect
class_name InventoryGUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var exit_button: TextureButton = %ExitButton
@onready var slotsContainer = $centerContainer/Book/Slots
@onready var player: Player = $"../.."
@onready var timer: Timer = $timer
@onready var book: BookTexture = $centerContainer/Book

enum Functions { PICK, PUT, SWAP}
var playerInventoryManager: InventoryManager
var playerManager: PlayerManager
var holding_item = null
var isPressed: bool = false
var activeSlot : Slot
var activeConfig: DataEnums.PickSize
var activeFunction: Functions
var activeSecondTime = false
var activeTime = true
var startTime = 0.1
var offsetTime = 0.1

func _ready() -> void:
	playerInventoryManager = AllPlayerManager.getManagerByPlayer(player).inventoryManager
	playerManager = AllPlayerManager.getManagerByPlayer(player).playerManager
	
	playerManager.updateInventorySlots.connect(updateInventorySlots)
	playerManager.updateEquipmentSlots.connect(updateEquipmentSlots)
	exit_button.pressed.connect(unpause)
	visible = false
	
	updateInventorySlots(playerManager.inventorySlots)
	updateEquipmentSlots(playerManager.equipmentSlots)
	updateAccesoirSlots(playerManager.accesoirSlots)
	setupInventory()

func setupInventory() -> void:
	var slots: Array = getAllSlots()
	for inv_slot in slots:
		inv_slot.connect("gui_input", slot_gui_input.bind(inv_slot))
	initializeInventory()

func updateInventorySlots(inventorySlots: int) -> void:
	book.updateInventorySlots(inventorySlots)
	var slots: Array = getAllSlotsByCategorie(DataEnums.MainType.ITEM)
	for i in range(inventorySlots):
		slots[i].activated = true

func updateEquipmentSlots(equipmentSlots: int) -> void:
	book.updateEquipmentSlots(equipmentSlots)
	var slots: Array = getAllSlotsByCategorie(DataEnums.MainType.EQUIPMENT)
	for slot in slots:
		slot.activated = true
	
func updateAccesoirSlots(equipmentSlots: int) -> void:
	book.updateAccesoirSlots(equipmentSlots)
	var slots: Array = getAllSlotsByCategorie(DataEnums.MainType.ACCESSOIR)
	for slot in slots:
		slot.activated = true

func initializeInventory() -> void:
	var slots = getAllActivatedSlotsByCategorie(DataEnums.MainType.ITEM)
	for i in range(slots.size()):
		if playerInventoryManager.inventory.has(i):
			slots[i].initializeItem(playerInventoryManager.inventory[i][0], playerInventoryManager.inventory[i][1])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		isPressed = event.pressed
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func _process(_delta) -> void:
	if isPressed and activeSecondTime and activeTime and activeFunction == Functions.PICK:
		addPickItems(activeConfig, activeSlot)
		_changeTimer()
		activeTime = false
	elif not isPressed:
		activeSecondTime = false
		offsetTime = startTime

func _changeTimer() -> void:
	offsetTime -= 0.01
	offsetTime = clamp(offsetTime, 0.01, 1)
	timer.wait_time = offsetTime
	timer.start()

func getAllSlots() -> Array:
	var slots = []
	for inv_slots_holder in slotsContainer.get_children():
		slots.append_array(inv_slots_holder.get_children())
	return slots

func getAllActivatedSlotsByCategorie(mainType: DataEnums.MainType) -> Array[Slot]:
	var slots = []
	var allSlots: Array = getAllSlotsByCategorie(mainType)
	for slot in allSlots:
		if slot.activated:
			slots.append(slot)
	return slots
	
func getAllSlotsByCategorie(mainType: DataEnums.MainType) -> Array[Slot]:
	var slots = []
	for inv_slots_holder in slotsContainer.get_children():
		for slot in inv_slots_holder.get_children():
			if slot.mainType == mainType:
				slots.append(slot)
	return slots

func slot_gui_input(event: InputEvent, slot: Slot) -> void:
	if not slot.activated:
		return
	var strongAction = Input.is_action_pressed("strongAction")
	if not event is InputEventMouseButton:
		return
	activeSlot = slot
	if event.button_index == MOUSE_BUTTON_LEFT && event.pressed && strongAction:
		handleItemWithQuantity(DataEnums.PickSize.ONE, slot)
		activeConfig = DataEnums.PickSize.ONE
	elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed && strongAction:
		handleItemWithQuantity(DataEnums.PickSize.MINSTACKSIZE, slot)
		activeConfig = DataEnums.PickSize.MINSTACKSIZE
	elif event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		handleItemWithQuantity(DataEnums.PickSize.FULL, slot)
		activeConfig = DataEnums.PickSize.FULL
	elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
		handleItemWithQuantity(DataEnums.PickSize.HALF, slot)
		activeConfig = DataEnums.PickSize.HALF

func handleItemWithQuantity(type: DataEnums.PickSize, slot: Slot) -> void:
	activeConfig = type
	if holding_item == null:
		pickItems(type, slot)
	else:
		if slot.itemData == null and canPlaceInSlot(slot):
			putItems(type, slot)
		else:
			swapItems(type, slot)
	activeSecondTime = true
	activeTime = false
	timer.wait_time = startTime * 2
	timer.start()

func swapItems(type: DataEnums.PickSize, slot: Slot) -> void:
	activeFunction = Functions.SWAP
	if canPlaceInSlot(slot) and type == DataEnums.PickSize.FULL:
		if holding_item.itemID != slot.itemData.itemID:
			swapTwoItems(slot, type)
			return
		elif holding_item.itemID == slot.itemData.itemID:
			var stack_size = ItemLoader.getItem(slot.itemData.itemID).stackSize
			var able_to_add = stack_size - slot.itemData.item_quantity
			if able_to_add >= holding_item.item_quantity:
				activeFunction = Functions.PICK
				addPickItems(type, slot)
				return
			elif slot.itemData.item_quantity == stack_size:
				swapTwoItems(slot, type)
				return
			slot.item.addItemQuantity(able_to_add)
			holding_item.decreaseItemQuantity(able_to_add)
	elif canPlaceInSlot(slot):
		if holding_item.itemID == slot.itemData.itemID:
			var stack_size = ItemLoader.getItem(slot.itemData.itemID).stackSize
			if holding_item.item_quantity < stack_size:
				activeFunction = Functions.PICK
				addPickItems(type, slot)
				return

func swapTwoItems(slot: Slot, type: DataEnums.PickSize):
	remove_child(holding_item)
	var temp_item = slot.pickFromSlot(type)
	removeFromInventory(slot)
	temp_item.global_position = get_global_mouse_position()
	slot.putIntoSlot(holding_item, type)
	putInInventory(slot.itemData, slot)
	add_child(temp_item)
	holding_item = temp_item

func pickItems(type: DataEnums.PickSize, slot: Slot):
	if not slot.itemData:
		return
	activeFunction = Functions.PICK
	holding_item = slot.pickFromSlot(type)
	holding_item.global_position = get_global_mouse_position()
	add_child(holding_item)
	updateInventory(slot.itemData, slot)

func addPickItems(type: DataEnums.PickSize, slot: Slot):
	if not slot.itemData:
		return
	var stack_size = ItemLoader.getItem(holding_item.itemID).stackSize
	if holding_item.item_quantity < stack_size and slot.itemData:
		var temp_item: ItemData = slot.pickFromSlot(type)
		remove_child(holding_item)
		holding_item.addItemQuantity(temp_item.item_quantity)
		holding_item.global_position = get_global_mouse_position()
		add_child(holding_item)
		updateInventory(slot.itemData, slot)

func putItems(type: DataEnums.PickSize, slot: Slot):
	activeFunction = Functions.PUT
	remove_child(holding_item)
	holding_item = slot.putIntoSlot(holding_item, type)
	if not slot.itemData:
		return
	putInInventory(slot.itemData , slot)
	if holding_item:
		add_child(holding_item)

func canPlaceInSlot(slot: Slot) -> bool:
	if slot.mainType == DataEnums.MainType.ITEM:
		return true
	if slot.mainType != holding_item.mainType or slot.itemType != holding_item.itemType or slot.itemSubType != holding_item.itemSubType:
		return false
	return true

func putInInventory(itemData: ItemData,slot: Slot):
	var slotIndex = getAllSlots().find(slot)
	playerInventoryManager.addToSlot(itemData, slotIndex)

func updateInventory(itemData: ItemData, slot: Slot):
	var slotIndex = getAllSlots().find(slot)
	playerInventoryManager.updateSlot(itemData, slotIndex)

func removeFromInventory(slot: Slot):
	var slotIndex = getAllSlots().find(slot)
	playerInventoryManager.removeSlot(slotIndex)

func unpause() -> void:
	animation_player.play("Unpause")
	get_tree().paused = false

func pause() -> void:
	animation_player.play("Pause")
	get_tree().paused = true

func _on_timer_timeout():
	activeTime = true
