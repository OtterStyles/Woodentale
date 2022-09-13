extends ColorRect
@onready var hotbar_slots = %hotbarSlots
@onready var timer = $timer
@onready var player = $"../.."
var activeHotBarRow = 0
var playerInventoryManager: InventoryManager
var canRotateAgain = true

func _ready():
	playerInventoryManager = AllPlayerManager.players[player.name].inventoryManager
	playerInventoryManager.connect("inventoryChanged", initializeInventory)
	timer.wait_time = 0.1
	initializeInventory()

func _input(event):
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
			slots[i].updateItem(playerInventoryManager.inventory[keyIndex][0], playerInventoryManager.inventory[keyIndex][1])
		else:
			slots[i].clear()

func _on_timer_timeout():
	canRotateAgain = true
