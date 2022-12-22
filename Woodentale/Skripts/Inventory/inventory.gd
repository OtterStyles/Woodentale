extends ColorRect

const SlotClass = preload("res://Skripts/Inventory/Slot.gd")
var ItemClass = preload("res://PreFab/Inventory/item.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var exit_button: TextureButton = %ExitButton
@onready var slotsContainer = $centerContainer/Book/Slots
@onready var player = $"../.."
@onready var timer: Timer = $timer
@onready var book: BookTexture = $centerContainer/Book

enum Functions { PICK, PUT, SWAP}
var playerInventoryManager: InventoryManager
var playerManager: PlayerManager
var holding_item = null
var isPressed: bool = false
var activeSlot : SlotClass
var activeConfig: DataEnums.PickSize
var activeFunction: Functions
var activeSecondTime = false
var activeTime = true
var startTime = 0.1
var offsetTime = 0.1

func _ready() -> void:
	playerInventoryManager = AllPlayerManager.players[player.name].inventoryManager
	playerManager = AllPlayerManager.players[player.name].playerManager
	playerManager.updateInventorySlots.connect(updateInventorySlots)
	playerManager.updateEquipmentSlots.connect(updateEquipmentSlots)
	# https://www.youtube.com/watch?v=g1x8ct2Slok
	visible = false
	exit_button.pressed.connect(unpause)
	
	updateInventorySlots(playerManager.inventorySlots)
	updateEquipmentSlots(playerManager.equipmentSlots)
	updateAccesoirSlots(playerManager.accesoirSlots)
	
	var slots: Array[SlotClass] = getAllSlots()
	for inv_slot in slots:
		inv_slot.connect("gui_input", slot_gui_input.bind(inv_slot))
	initializeInventory()

func updateInventorySlots(inventorySlots: int):
	book.updateInventorySlots(inventorySlots)
	var slots: Array[SlotClass] = getAllSlotsByCategorie(DataEnums.MainType.ITEM)
	for i in range(inventorySlots):
		slots[i].activated = true

func updateEquipmentSlots(equipmentSlots: int):
	book.updateEquipmentSlots(equipmentSlots)
	var slots: Array[SlotClass] = getAllSlotsByCategorie(DataEnums.MainType.EQUIPMENT)
	for slot in slots:
		slot.activated = true
	
func updateAccesoirSlots(equipmentSlots: int):
	book.updateAccesoirSlots(equipmentSlots)
	var slots: Array[SlotClass] = getAllSlotsByCategorie(DataEnums.MainType.ACCESSOIR)
	for slot in slots:
		slot.activated = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		isPressed = event.pressed
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
		holding_item.global_position = get_global_mouse_position()

func _process(delta):
	if isPressed and activeSecondTime and activeTime and activeFunction == Functions.PICK:
		addPickItems(activeConfig, activeSlot)
		offsetTime -= 0.01
		offsetTime = clamp(offsetTime, 0.01, 1)
		timer.wait_time = offsetTime
		timer.start()
		activeTime = false
	elif not isPressed:
		activeSecondTime = false
		offsetTime = startTime

func getAllSlots():
	var slots = []
	for inv_slots_holder in slotsContainer.get_children():
		slots.append_array(inv_slots_holder.get_children())
	return slots

func getAllSlotsByCategorie(mainType: DataEnums.MainType):
	var slots = []
	for inv_slots_holder in slotsContainer.get_children():
		for slot in inv_slots_holder.get_children():
			if slot.mainType == mainType:
				slots.append(slot)
	return slots

func getAllActivatedSlotsByCategorie(mainType: DataEnums.MainType):
	var slots = []
	var allSlots: Array[SlotClass] = getAllSlotsByCategorie(mainType)
	for slot in allSlots:
		if slot.activated:
			slots.append(slot)
	return slots
	
func initializeInventory() -> void:
	var slots = getAllActivatedSlotsByCategorie(DataEnums.MainType.ITEM)
	for i in range(slots.size()):
		if playerInventoryManager.inventory.has(i):
			slots[i].initializeItem(playerInventoryManager.inventory[i][0], playerInventoryManager.inventory[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass) -> void:
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

func handleItemWithQuantity(type: int, slot: SlotClass) -> void:
	activeConfig = type
	if holding_item == null:
		pickItems(type, slot)
	else:
		if slot.item == null and canPlaceInSlot(slot):
			putItems(type, slot)
		else:
			swapItems(type, slot)
	activeSecondTime = true
	activeTime = false
	timer.wait_time = startTime * 2
	timer.start()

func swapItems(type: DataEnums.PickSize, slot: SlotClass) -> void:
	activeFunction = Functions.SWAP
	if canPlaceInSlot(slot) and type == DataEnums.PickSize.FULL:
		if holding_item.itemID != slot.item.itemID:
			swapTwoItems(slot, type)
			return
		elif holding_item.itemID == slot.item.itemID:
			var stack_size = ItemLoader.getItem(slot.item.itemID).stackSize
			var able_to_add = stack_size - slot.item.item_quantity
			if able_to_add >= holding_item.item_quantity:
				activeFunction = Functions.PICK
				addPickItems(type, slot)
				return
			elif slot.item.item_quantity == stack_size:
				swapTwoItems(slot, type)
				return
			slot.item.addItemQuantity(able_to_add)
			holding_item.decreaseItemQuantity(able_to_add)
	elif canPlaceInSlot(slot):
		if holding_item.itemID == slot.item.itemID:
			var stack_size = ItemLoader.getItem(slot.item.itemID).stackSize
			if holding_item.item_quantity < stack_size:
				activeFunction = Functions.PICK
				addPickItems(type, slot)
				return

func swapTwoItems(slot: SlotClass, type: DataEnums.PickSize):
	remove_child(holding_item)
	var temp_item = slot.pickFromSlot(type)
	removeFromInventory(slot)
	temp_item.global_position = get_global_mouse_position()
	slot.putIntoSlot(holding_item, type)
	putInInventory(slot.item, slot)
	add_child(temp_item)
	holding_item = temp_item

func pickItems(type: DataEnums.PickSize, slot: SlotClass):
	if not slot.item:
		return
	activeFunction = Functions.PICK
	holding_item = slot.pickFromSlot(type)
	holding_item.global_position = get_global_mouse_position()
	add_child(holding_item)
	updateInventory(slot.item, slot)

func addPickItems(type: DataEnums.PickSize, slot: SlotClass):
	if not slot.item:
		return
	var stack_size = ItemLoader.getItem(holding_item.itemID).stackSize
	if holding_item.item_quantity < stack_size and slot.item:
		var temp_item: ItemData = slot.pickFromSlot(type)
		remove_child(holding_item)
		holding_item.addItemQuantity(temp_item.item_quantity)
		holding_item.global_position = get_global_mouse_position()
		add_child(holding_item)
		updateInventory(slot.item, slot)

func putItems(type: DataEnums.PickSize, slot: SlotClass):
	activeFunction = Functions.PUT
	remove_child(holding_item)
	holding_item = slot.putIntoSlot(holding_item, type)
	if not slot.item:
		return
	putInInventory(slot.item , slot)
	if holding_item:
		add_child(holding_item)

func canPlaceInSlot(slot: SlotClass) -> bool:
	if slot.mainType == DataEnums.MainType.ITEM:
		return true
	if slot.mainType != holding_item.mainType or slot.itemType != holding_item.itemType or slot.itemSubType != holding_item.itemSubType:
		return false
	return true

func putInInventory(item: ItemData,slot: SlotClass):
	var slotIndex = getAllSlots().find(slot)
	playerInventoryManager.addToSlot(item, slotIndex)

func updateInventory(item: ItemData, slot: SlotClass):
	var slotIndex = getAllSlots().find(slot)
	playerInventoryManager.updateSlot(item, slotIndex)

func removeFromInventory(slot: SlotClass):
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
