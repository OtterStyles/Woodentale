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
var direction = Vector2()
onready var animationTree = $Animation/AnimationTree
const animationsName = ['Working','Walking','Idle']

func _unhandled_input(event) -> void:
	direction = Vector2()
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("sprint"):
		sprint = speed_Sprint_Mult
	else:
		sprint = 1
	direction.normalized()
	handleAnimation()
	
func handleAnimation() -> void:
	for param in animationsName:
		animationTree.set("parameters/"+param+"/blend_position", direction)
	
	
func calculateStats() -> void:
	speed = (speed_Default + speedAbs) * speedPerc 


func _process(delta) -> void:
	calculateStats()
	
	
func _physics_process(delta) -> void:
	if direction.length() > 0:
		velocity = lerp(velocity, direction * speed * sprint, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity * delta)
