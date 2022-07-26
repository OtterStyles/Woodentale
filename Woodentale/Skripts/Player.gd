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
var direction
const animationsName = ['Working','Walking','Idle','Atacking']
var animationStateMachine;
func _ready():
	animationStateMachine = $Animation/AnimationTree.get("parameters/playback")
func _process(delta) -> void:
	calculateStats()
	
func _physics_process(delta) -> void:
	getInput()
	handleMovement(delta)
	move_and_slide()

func getInput() -> void:
	sprint = 1
	var current = animationStateMachine.get_current_node()
	if Input.is_action_pressed("work"):
		handleAnimations("Working")
		return
	if Input.is_action_pressed("sprint"):
		sprint = SPEED_SPRINT_MULT
	handleMovementInputs()

func handleMovementInputs():
	direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	if direction != Vector2.ZERO:
		changeBlendPositions(direction)
	direction = direction.normalized()

func handleMovement(delta: float) -> void:
	if direction == Vector2.ZERO:
		handleAnimations("Idle")
		applyFriction(FRICTION * delta)
	else:
		handleAnimations("Walking")
		applyMovement(direction * ACCELERATION * delta)
		applyFrictionOnUnsuedAxis(direction, FRICTION*delta)

func applyMovement(acceleration: Vector2) -> void:
	velocity += acceleration
	velocity.x = clamp(velocity.x, -SPEED*sprint, SPEED*sprint)
	velocity.y = clamp(velocity.y, -SPEED*sprint*0.8, SPEED*sprint*0.8)

func applyFriction(friction: float) -> void:
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


func handleAnimations(changePostionTo: String) -> void:
	animationStateMachine.travel(changePostionTo)

func calculateStats() -> void:
	SPEED = (SPEED_DEFAULT + SPEEDABS) * SPEEDPERC


