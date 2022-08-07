extends ColorRect

@onready var animation_player = $AnimationPlayer
@onready var resume_button = %ResumeButton
@onready var quit_button = %QuitButton

func _ready():
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func pause():
	animation_player.play("Pause")
	get_tree().paused = true
	
func unpause():
	animation_player.play("Unpause")
	get_tree().paused = false
