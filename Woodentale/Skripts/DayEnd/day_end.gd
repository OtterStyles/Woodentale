extends ColorRect

@onready var continue_button: Button = %continueButton

func _ready() -> void:
	TimeManager.dayEnd.connect(beginEndDay)
	continue_button.pressed.connect(endEndDay)
	visible = false

func beginEndDay() -> void:
	visible = true
	
func endEndDay() -> void:
	get_tree().paused = false
	visible = false
	TimeManager.restartDay()
	
