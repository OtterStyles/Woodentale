extends KinematicBody2D

#Stats
export var SPEEDABS: float = 0
export var SPEEDPERC: float = 1
export var SPEED_DEFAULT: int = 300
export var SPEED_SPRINT_MULT: float = 1.2
export var ACCELERATION: float = 1000
export var FRICTION: float = 1500

# Movement
var velocity = Vector2()
var SPEED = 0
var sprint = 1
const animationsName = ['Working','Walking','Idle']

	
func _process(delta) -> void:
	calculateStats()
	
func _physics_process(delta) -> void:
	var axis = getInputAxis()
	if axis == Vector2.ZERO:
		applyFriction(FRICTION * delta)
	else:
		applyMovement(axis * ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func _unhandled_input(event) -> void:
	sprint = 1
	if Input.is_action_pressed("sprint"):
		sprint = SPEED_SPRINT_MULT

func applyMovement(acceleration: Vector2):
	$Animation/AnimationTree.get("parameters/playback").travel("Walking")
	velocity += acceleration
	velocity = velocity.clamped(SPEED * sprint)

func applyFriction(friction):
	$Animation/AnimationTree.get("parameters/playback").travel("Idle")
	if velocity.length() > friction:
		velocity -= velocity.normalized() * friction
	else:
		velocity = Vector2.ZERO

func handleAnimation(direction: Vector2) -> void:
	for param in animationsName:
		$Animation/AnimationTree.set("parameters/"+param+"/blend_position", direction)
	
	
func calculateStats() -> void:
	SPEED = (SPEED_DEFAULT + SPEEDABS) * SPEEDPERC

func getInputAxis():
	var direction = Vector2()
	direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	if direction != Vector2.ZERO:
		handleAnimation(direction)
	return direction.normalized()
