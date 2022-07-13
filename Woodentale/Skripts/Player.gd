extends KinematicBody2D

# Movement
var velocity = Vector2()
var speed = PlayerStats.Movement.Speed


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
	speed = (PlayerStats.Movement.Speed + PlayerStats.Multiplier.SpeedAbs) * PlayerStats.Multiplier.SpeedPerc 


func _process(delta):
	calculateStats()
	var direction = getInput()
	if direction.length() > 0:
		velocity = lerp(velocity, direction * speed, PlayerStats.Movement.Acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, PlayerStats.Movement.Friction)
	velocity = move_and_slide(velocity * delta)
