extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton
@onready var settings_button = %SettingsButton
signal changeToSettings 

func _ready() -> void:
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)
	settings_button.pressed.connect(openSettings)

func openSettings() -> void:
	changeToSettings.emit()

func pause() -> void:
	animation_player.play("Pause")
	get_tree().paused = true

func pauseHard() -> void:
	animation_player.play("PauseHard")
	
func unpauseHard() -> void:
	animation_player.play("UnpauseHard")

func unpause() -> void:
	animation_player.play("Unpause")
	get_tree().paused = false
