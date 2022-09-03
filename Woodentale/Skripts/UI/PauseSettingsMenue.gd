extends Control

@onready var pause_menu = $PauseMenu
@onready var settings_menue = $SettingsMenue

func _ready():
	pause_menu.connect("changeToSettings", openSettings)
	settings_menue.connect("changeToPause", closeSettings)

func pause() -> void:
	pause_menu.pause()
	
func openSettings() -> void:
	pause_menu.unpauseHard()
	settings_menue.enable()

func closeSettings() -> void:
	pause_menu.pauseHard()

func unpause() -> void:
	pause_menu.unpause()
