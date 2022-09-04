extends CanvasLayer

@onready var inventory = $Inventory
@onready var pause_settings_menue = $PauseSettingsMenue
@onready var player = $".."


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory.pause()
		inventory.initializeInventory()
	if event.is_action_pressed("ui_cancel"):
		pause_settings_menue.pause()
