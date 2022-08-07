extends CanvasLayer

@onready var inventory = $Inventory
@onready var pause_menu = $PauseMenu

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory.pause()
		inventory.initializeInventory()
	if event.is_action_pressed("ui_cancel"):
		pause_menu.pause()
