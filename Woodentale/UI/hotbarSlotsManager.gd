extends GridContainer
@onready var hot_frame: Sprite2D = $HotFrame



func moveFrameLeft():
	if hot_frame.position.x > 25:
		hot_frame.position.x -= 54
	
func moveFrameRight():
	if hot_frame.position.x < 295:
		hot_frame.position.x += 54

func moveFrameSet(number: int):
	var offset = 25 + (number - 1) * 54
	if offset >= 25 and offset <= 295:
		hot_frame.position.x = offset
