extends ColorRect
@onready var exit_button = %exitButton
@onready var animation_player = $animationPlayer
signal changeToPause

func _ready():
	exit_button.pressed.connect(disable)

func enable() -> void:
	animation_player.play("enable")
	
func disable() -> void:
	animation_player.play("disable")
	changeToPause.emit()
