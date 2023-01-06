extends ColorRect
class_name HotBar

@onready var hotbar_slots: Control = %hotbarSlots
@onready var timer: Timer = $timer
@onready var player: Player = $"../.."

var activeHotBarRow: int = 0
var playerInventoryManager: InventoryManager
var canRotateAgain: bool = true

func _ready() -> void:
	playerInventoryManager = AllPlayerManager.getManagerByPlayer(player).inventoryManager
	var handHoldManager: HandHoldManager = AllPlayerManager.getManagerByPlayer(player).handHoldManager
	handHoldManager.connect("changeToolStamina", updateToolStamina)
	playerInventoryManager.connect("inventoryChanged", initializeInventory)
	timer.wait_time = 0.1
	initializeInventory()
	

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		if event is InputEventMouseButton and canRotateAgain:
			timer.start()
			canRotateAgain = false
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && event.pressed:
				activeHotBarRow += playerInventoryManager.COLUMN
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && event.pressed:
				activeHotBarRow -= playerInventoryManager.COLUMN
			activeHotBarRow = clampi(activeHotBarRow, 0, playerInventoryManager.NUM_INVENTORY_SLOTS - playerInventoryManager.COLUMN)
			initializeInventory()

func initializeInventory() -> void:
	var slots = hotbar_slots.get_children()
	for i in range(playerInventoryManager.COLUMN):
		var keyIndex = activeHotBarRow + i
		if playerInventoryManager.inventory.has(keyIndex):
			slots[keyIndex].updateItem(playerInventoryManager.inventory[keyIndex][0], playerInventoryManager.inventory[keyIndex][1])
		else:
			slots[keyIndex].clearHotBarSlot()
	%hotbarSlots.enableHotFrame()

func _on_timer_timeout() -> void:
	canRotateAgain = true
	
func getHotBarIndex() -> int:
	return %hotbarSlots.numberActiveFrame

func getHotBarActiveItem() -> ItemData:
	var index = getHotBarIndex()
	return %hotbarSlots.get_child(index).get_child(0)
	
func updateToolStamina(value: int, _item: ItemResource) -> void:
	var slots = hotbar_slots.get_children()
	for i in range(playerInventoryManager.COLUMN):
		var keyIndex = activeHotBarRow + i
		if slots[keyIndex].itemData.item == _item:
			slots[i].changeToolStamina(value)
