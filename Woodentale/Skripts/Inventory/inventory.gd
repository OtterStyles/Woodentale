extends ColorRect

const SlotClass = preload("res://Skripts/Inventory/Slot.gd")
@onready var inventory_slots: GridContainer = %InventorySlots
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var exit_button = %ExitButton


var holding_item = null;

func _ready():
	# https://www.youtube.com/watch?v=g1x8ct2Slok
	exit_button.pressed.connect(unpause)
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", slot_gui_input, [inv_slot])
	initializeInventory()
	
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func initializeInventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initializeItem(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if not event is InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if holding_item != null:
			if !slot.item:
				slot.putIntoSlot(holding_item)
				holding_item = null;
			else:
				swapItems(event, slot)
		elif slot.item:
			holding_item = slot.item
			slot.pickFromSlot()
			holding_item.global_position = get_global_mouse_position()

func swapItems(event: InputEvent, slot: SlotClass) -> void:
	if holding_item.item_name != slot.item.item_name:
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(holding_item)
		holding_item = temp_item
		return
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		slot.item.addItemQuantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
		return
	slot.item.addItemQuantity(able_to_add)
	holding_item.decreaseItemQuantity(able_to_add)


func unpause():
	animation_player.play("Unpause")
	get_tree().paused = false
	
func pause():
	animation_player.play("Pause")
	get_tree().paused = true
