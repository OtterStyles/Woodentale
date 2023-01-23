extends CharacterBody2D
class_name Player
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
	ATTACKING,
	INTERACT
}
var state = MOVE
var animationName = ['Working','Idle','Walking','Attacking','Interact']

@onready var animationStateMachine = $Animation/AnimationTree.get("parameters/playback");
@onready var animationTree = $Animation/AnimationTree
@onready var player_manager: PlayerManager = $Manager/PlayerManager
@onready var pivot_manager: PivotManager = $Manager/PivotManager
@onready var handHold_manager: HandHoldManager = $Manager/HandHoldManager
@onready var gui = $GUI
@onready var camera_2d = $Camera2D

var timer: Timer = Timer.new()
var canChangeHotBar = true
var singleUseHolder = false

func _ready() -> void:
	timer.wait_time = 0.8
	timer.autostart = true
	timer.timeout.connect(timerTimeOut)
	add_child(timer)
	animationTree.active = true;

func _process(_delta) -> void:
	calculateStats()
	changeHandItem()
	
func _physics_process(delta) -> void:
	match state:
		MOVE:
			move_state(delta)
		WORKING:
			working_state(delta)
		INTERACT:
			interact_state(delta)
		ATTACKING:
			pass

func move_state(delta: float) -> void:
	getInput()
	handleMovement(delta)
	move_and_slide()

func working_state(delta: float) -> void:
	handelAnimation("Working")
	applyFriction(FRICTION * delta)
	if not handHold_manager.coolDown: 
		handHold_manager.useTool()
		handHold_manager.coolDown = true

func interact_state(delta: float) -> void:
	handelAnimation("Interact")
	applyFriction(FRICTION * delta)

	
func getInput() -> void:
	sprint = 1
	if Input.is_action_pressed("work"):
		state = WORKING
	if Input.is_action_pressed("sprint"):
		sprint = SPEED_SPRINT_MULT
	if Input.is_action_just_pressed("interact"):
		state = INTERACT
	handleMovementInputs()

func _input(event: InputEvent) -> void:
	if not Input.is_key_pressed(KEY_SHIFT):
		if event is InputEventMouseButton and canChangeHotBar:
			timer.start(0.1)
			canChangeHotBar = false
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				gui.hot_bar.hotbar_slots.moveFrameLeft()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				gui.hot_bar.hotbar_slots.moveFrameRight()
		if event is InputEventKey:
			if not event.as_text().to_lower() in DataConstants.ASCII_LOWERCASE:
				gui.hot_bar.hotbar_slots.setFrame(event.as_text().to_int() - 1)

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

func changeHandItem() -> void:
	var item: ItemData = gui.hot_bar.getHotBarActiveItem()
	var currentToolType = handHold_manager.type
	if item:
		if item.itemSubType != currentToolType:
			handHold_manager.changeItem(item.item)
		return
	handHold_manager.changeItem(null)

func handelAnimation(NodeName: StringName) -> void:
	animationStateMachine.travel(NodeName)

func resetAnimationState() -> void:
	state = MOVE
	handHold_manager.coolDown = false

func timerTimeOut() -> void:
	canChangeHotBar = true


func _on_interact_hurtbox_body_entered(body):
	if body is TileMap:
		var tile = body.get_cell_tile_data(3,body.local_to_map( $Collision/InteractHurtbox.global_position) )
		print(tile)
