extends GridContainer

var numberActiveFrame = 0
var maxActiveFrames = 0

func _ready():
	maxActiveFrames = len(get_children(0)) - 1

func moveFrameLeft():
	disableHotFrame()
	numberActiveFrame = clampi(numberActiveFrame - 1, 0, maxActiveFrames)
	enableHotFrame()
	
func moveFrameRight():
	disableHotFrame()
	numberActiveFrame = clampi(numberActiveFrame + 1, 0, maxActiveFrames)
	enableHotFrame()

func setFrame(number: int):
	disableHotFrame()
	numberActiveFrame = clampi(number, 0, maxActiveFrames)
	enableHotFrame()


func disableHotFrame() -> void:
	get_child(numberActiveFrame).get_child(0).updateHotFrame(false)

func enableHotFrame() -> void:
	get_child(numberActiveFrame).get_child(0).updateHotFrame(true)
	
