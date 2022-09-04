extends ColorRect
@onready var hotbar_slots = %hotbarSlots
@onready var timer = $timer
@onready var player = $"../.."
var activeHotBarRow = 0
var playerInventoryManager
var canRotateAgain = true

func _ready():
	playerInventoryManager = AllPlayerManager.players[player.name]['InventoryManager']
	playerInventoryManager.connect("inventoryChanged", initializeInventory)
	timer.wait_time = 0.1
	initializeInventory()

func _input(event):
	if event is InputEventMouseButton and canRotateAgain:
		timer.start()
		canRotateAgain = false
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && event.pressed:
			activeHotBarRow += 6
		if event.button_index == MOUSE_BUTTON_WHEEL_UP && event.pressed:
			activeHotBarRow -= 6
		activeHotBarRow = clampi(activeHotBarRow, 0, 25)
		initializeInventory()

func initializeInventory() -> void:
	var slots = hotbar_slots.get_children()
	for i in range(6):
		var keyIndex = activeHotBarRow + i
		if playerInventoryManager.inventory.has(keyIndex):
			slots[i].updateItem(playerInventoryManager.inventory[keyIndex][0], playerInventoryManager.inventory[keyIndex][1])
		else:
			slots[i].clear()

func _on_timer_timeout():
	canRotateAgain = true
