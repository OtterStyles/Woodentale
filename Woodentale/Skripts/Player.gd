extends KinematicBody2D

#Stats
export var speedAbs: float = 0
export var speedPerc: float = 1
export var speed_Default: int = 400
export var speed_Sprint_Mult: float = 1.5
export var acceleration: float = 40
export var friction: float = 30

# Movement
var velocity = Vector2()
var speed = 0
var sprint = 1

func getInput() -> Vector2:
	var input = Vector2()
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	if Input.is_action_pressed("sprint"):
		sprint = speed_Sprint_Mult
	else:
		sprint = 1
	return input
	
	
func calculateStats() -> void:
	speed = (speed_Default + speedAbs) * speedPerc 


func _process(delta) -> void:
	calculateStats()
	
	
func _physics_process(delta) -> void:
	var direction = getInput().normalized()
	if direction.length() > 0:
		velocity = lerp(velocity, direction * speed * sprint, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity * delta)
