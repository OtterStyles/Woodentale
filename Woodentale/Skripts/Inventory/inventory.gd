extends ColorRect

const SlotClass = preload("res://Skripts/Inventory/Slot.gd")
var ItemClass = preload("res://PreFab/Inventory/item.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var exit_button: Button = %ExitButton
@onready var slotsContainer = $centerContainer/TextureRect/Slots
@onready var player = $"../.."

var playerInventoryManager: InventoryManager
enum PickSize { ONE, MINSTACKSIZE, HALF, FULL}
var holding_item = null

func _ready() -> void:
	playerInventoryManager = AllPlayerManager.players[player.name].inventoryManager
	# https://www.youtube.com/watch?v=g1x8ct2Slok
	exit_button.pressed.connect(unpause)
	var slots: Array[SlotClass] = getAllSlots()
	for inv_slot in slots:
		inv_slot.connect("gui_input", slot_gui_input.bind(inv_slot))
	initializeInventory()
	
func _input(_event: InputEvent) -> void:
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func getAllSlots():
	var slots = []
	for inv_slots_holder in slotsContainer.get_children():
		slots.append_array(inv_slots_holder.get_children())
	return slots
	
func initializeInventory() -> void:
	var slots = getAllSlots()
	for i in range(slots.size()):
		if playerInventoryManager.inventory.has(i):
			slots[i].initializeItem(playerInventoryManager.inventory[i][0], playerInventoryManager.inventory[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass) -> void:
	var strongAction = Input.is_action_pressed("strongAction")
	if not event is InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT && event.pressed && strongAction:
		handleItemWithQuantity(PickSize.ONE, slot)
	elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed && strongAction:
		handleItemWithQuantity(PickSize.MINSTACKSIZE, slot)
	elif event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		handleItemWithQuantity(PickSize.FULL, slot)
	elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
		handleItemWithQuantity(PickSize.HALF, slot)

func handleItemWithQuantity(type: int, slot: SlotClass) -> void:
	if holding_item == null and slot.item != null:
		pickItems(type, slot)
	else:
		if slot.item == null and canPlaceInSlot(slot):
			putItems(type, slot)
		else:
			swapItems(type, slot)
			
func swapItems(type: DataEnums.PickSize, slot: SlotClass) -> void:
	if canPlaceInSlot(slot) and type == DataEnums.PickSize.FULL:
		if holding_item.itemID != slot.item.itemID:
			swapTwoItems(slot, type)
			return
		elif holding_item.itemID == slot.item.itemID:
			var stack_size = ItemLoader.getItem(slot.item.itemID).stackSize
			var able_to_add = stack_size - slot.item.item_quantity
			if able_to_add >= holding_item.item_quantity:
				slot.item.addItemQuantity(holding_item.item_quantity)
				holding_item.queue_free()
				holding_item = null
				return
			elif slot.item.item_quantity == stack_size:
				swapTwoItems(slot, type)
				return
			slot.item.addItemQuantity(able_to_add)
			holding_item.decreaseItemQuantity(able_to_add)
			
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
	holding_item = slot.pickFromSlot(type)
	holding_item.global_position = get_global_mouse_position()
	add_child(holding_item)
	updateInventory(slot.item, slot)
	
func putItems(type: DataEnums.PickSize, slot: SlotClass):
	remove_child(holding_item)
	holding_item = slot.putIntoSlot(holding_item, type)
	putInInventory(slot.item, slot)
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
