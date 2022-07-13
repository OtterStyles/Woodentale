extends KinematicBody2D

# Movement
var velocity = Vector2()
export var playerDefaultStats: Resource
export var playerDefaultModifier: Resource

var speed = 0

func getInput():
	var input = Vector2()
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	return input

func calculateStats():
	speed = (playerDefaultStats.Speed + playerDefaultModifier.SpeedAbs) * playerDefaultModifier.SpeedPerc 


func _process(delta):
	calculateStats()
	var direction = getInput().normalized()
	if direction.length() > 0:
		velocity = lerp(velocity, direction * speed, playerDefaultStats.Acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, playerDefaultStats.Friction)
	velocity = move_and_slide(velocity)
