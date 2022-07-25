extends CharacterBody2D

#Stats
@export var SPEEDABS: float = 0
@export var SPEEDPERC: float = 1
@export var SPEED_DEFAULT: int = 300
@export var SPEED_SPRINT_MULT: float = 1.2
@export var ACCELERATION: float = 1000
@export var FRICTION: float = 1500

# Movement
var SPEED = 0
var sprint = 1
const animationsName = ['Working','Walking','Idle']
var animationStates: = {
	'Idle': 0,
	'Walking': 1,
	'Working': 2
}
var animationHandler = 0
	
func _process(delta) -> void:
	calculateStats()
	
func _physics_process(delta) -> void:
	var axis = getInputAxis()
	handleMovement(axis, delta)
	move_and_slide()

func _unhandled_input(event) -> void:
	sprint = 1
	if Input.is_action_pressed("sprint"):
		sprint = SPEED_SPRINT_MULT
	if Input.is_action_pressed("work"):
		handleWorkMovement()

func handleMovement(axis: Vector2, delta: float) -> void:
	if axis == Vector2.ZERO:
		applyFriction(FRICTION * delta)
	else:
		applyMovement(axis * ACCELERATION * delta)
		applyFrictionOnUnsuedAxis(axis, FRICTION*delta)

func applyMovement(acceleration: Vector2):
	handleAnimations("Walking")
	velocity += acceleration
	velocity.x = clamp(velocity.x, -SPEED*sprint, SPEED*sprint)
	velocity.y = clamp(velocity.y, -SPEED*sprint*0.8, SPEED*sprint*0.8)

func applyFriction(friction: float) -> void:
	handleAnimations("Idle")
	if velocity.length() > friction:
		velocity -= velocity.normalized() * friction
	else:
		velocity = Vector2.ZERO

func applyFrictionOnUnsuedAxis(axis: Vector2, friction: float) -> void:
	if axis.x == 0:
		if (velocity.x > friction and velocity.x > 0) or (velocity.x < friction and velocity.x < 0):
			velocity.x -= velocity.normalized().x * friction
		else:
			velocity.x = Vector2.ZERO.x
		return
	if axis.y == 0:
		if (velocity.y > friction and velocity.y > 0) or (velocity.y < friction and velocity.y < 0):
			velocity.y -= velocity.normalized().y * friction
		else:
			velocity.y = Vector2.ZERO.y
		return

func changeBlendPositions(direction: Vector2) -> void:
	for param in animationsName:
		$Animation/AnimationTree.set("parameters/"+param+"/blend_position", direction)
	
func handleWorkMovement() -> void:
	handleAnimations("Working")
	velocity = Vector2.ZERO

func handleAnimations(changePostionTo: String) -> void:
	if animationHandler != 2:
		$Animation/AnimationTree.get("parameters/playback").travel(changePostionTo)
		animationHandler = animationStates.get(changePostionTo)


func calculateStats() -> void:
	SPEED = (SPEED_DEFAULT + SPEEDABS) * SPEEDPERC

func getInputAxis():
	var direction = Vector2()
	direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	if direction != Vector2.ZERO:
		changeBlendPositions(direction)
	return direction.normalized()



func _on_animation_player_animation_finished(anim_name):
	if animationHandler == animationStates.get(anim_name):
		animationHandler = 0;
