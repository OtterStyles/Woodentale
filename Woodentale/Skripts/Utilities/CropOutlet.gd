extends Sprite2D
class_name CropOutlet

var startDay = 0

func _ready() -> void:
	startDay = TimeManager.globalDay
	TimeManager.connect("updateDay", updateDay)

func initCrop() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func updateDay(day: int) -> void:
	pass
