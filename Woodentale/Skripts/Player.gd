extends KinematicBody2D
	
	
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x = -PlayerStats.Movement.Speed
	if Input.is_action_pressed("ui_right"):
		velocity.x =  PlayerStats.Movement.Speed
	if Input.is_action_pressed("ui_up"):
		velocity.y = -PlayerStats.Movement.Speed
	if Input.is_action_pressed("ui_down"):
		velocity.y = PlayerStats.Movement.Speed

	move_and_slide(velocity)