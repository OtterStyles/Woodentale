extends Sprite2D

var startDay = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	startDay = TimeManager.globalDay
	TimeManager.connect("updateDay", updateDay)

func initCrop():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func updateDay(day: int):
	pass
