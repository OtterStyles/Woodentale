extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func pause() -> void:
	animation_player.play("Pause")
	get_tree().paused = true
	
func unpause() -> void:
	animation_player.play("Unpause")
	get_tree().paused = false
