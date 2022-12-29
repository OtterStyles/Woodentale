extends ColorRect

@onready var clock: Sprite2D = $control/centerContainer/sprite2d


# Called when the node enters the scene tree for the first time.
func _ready():
	TimeManager.connect("timeChange",updateTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateTime(time: float):
	if floori(time) < 24:
		clock.frame = floori(time)
