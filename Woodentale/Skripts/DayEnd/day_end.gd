extends ColorRect

@onready var continue_button: Button = %continueButton


# Called when the node enters the scene tree for the first time.
func _ready():
	TimeManager.dayEnd.connect(beginEndDay)
	continue_button.pressed.connect(endEndDay)
	visible = false

func beginEndDay():
	visible = true
	
func endEndDay():
	get_tree().paused = false
	visible = false
	TimeManager.restartDay()
	
