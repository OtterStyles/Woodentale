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
var direction = Vector2.ZERO

# Animations
enum {
	MOVE,
	WORKING,
	ATTACKING
}
var state = MOVE
var animationName = ['Working','Idle','Walking','Attacking']

@onready var animationStateMachine = $Animation/AnimationTree.get("parameters/playback");
@onready var animationTree = $Animation/AnimationTree
@onready var player_manager = $Manager/PlayerManager
@onready var pivot_manager = $Manager/PivotManager


func _ready():
	animationTree.active = true;

	
func _process(_delta) -> void:
	calculateStats()
	
func _physics_process(delta) -> void:
	match state:
		MOVE:
			move_state(delta)
		WORKING:
			working_state(delta)
		ATTACKING:
			pass


func move_state(delta: float) -> void:
	getInput()
	handleMovement(delta)
	move_and_slide()

func working_state(delta: float) -> void:
	handelAnimation("Working")
	applyFriction(FRICTION * delta)
	
func getInput() -> void:
	sprint = 1
	if Input.is_action_pressed("work"):
		state = WORKING
		return
	if Input.is_action_pressed("sprint"):
		sprint = SPEED_SPRINT_MULT
	handleMovementInputs()

func handleMovementInputs() -> void:
	direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	direction = direction.normalized()

func handleMovement(delta: float) -> void:
	if direction != Vector2.ZERO:
		changeBlendPositions()
		handelAnimation("Walking")
		applyMovement(direction * ACCELERATION * delta)
		applyFrictionOnUnusedAxis(direction, FRICTION*delta)
	else:
		handelAnimation("Idle")
		applyFriction(FRICTION * delta)

func applyMovement(acceleration: Vector2) -> void:
	velocity += acceleration
	velocity.x = clamp(velocity.x, -SPEED*sprint, SPEED*sprint)
	velocity.y = clamp(velocity.y, -SPEED*sprint*0.8, SPEED*sprint*0.8)

func applyFriction(friction: float) -> void:
	if velocity.length() > friction:
		velocity -= velocity.normalized() * friction
	else:
		velocity = Vector2.ZERO

func applyFrictionOnUnusedAxis(axis: Vector2, friction: float) -> void:
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

func changeBlendPositions() -> void:
	var safe = direction
	if safe == Vector2.ZERO: return
	for animName in animationName:
		animationTree.set("parameters/"+animName+"/blend_position", safe)

func calculateStats() -> void:
	SPEED = (SPEED_DEFAULT + SPEEDABS) * SPEEDPERC

func handelAnimation(NodeName: StringName) -> void:
	animationStateMachine.travel(NodeName)

func resetAnimationState() -> void:
	state = MOVE
