extends ColorRect
class_name OverHead

@onready var clock: Sprite2D = $control/centerContainer/sprite2d

func _ready() -> void:
	TimeManager.connect("timeChange",updateTime)

func updateTime(time: float) -> void:
	if floori(time) < 24:
		clock.frame = floori(time)
