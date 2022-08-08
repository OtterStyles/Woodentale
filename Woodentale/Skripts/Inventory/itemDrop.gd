extends CharacterBody2D

var player: CharacterBody2D = null
var beingPickedUp = false
var item_name: String

const SPEED = 200
const ACCELERATION = 400
const FRICTION = 200
const MAX_DISTANCE = 90
const MIN_DISTANCE = 5

func _ready() -> void:
	item_name = "Squisch Blue"

func _physics_process(delta: float) -> void:
	if beingPickedUp:
		var toPosition = player.pivot_manager.pivotPositions["CenterBody"]
		var direction = global_position.direction_to(toPosition)
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		var distance = global_position.distance_to(toPosition)
		if distance < MIN_DISTANCE:
			var isStored = PlayerInventory.addItem(item_name, 1)
			if isStored:
				queue_free()
			else:
				beingPickedUp = false
		if distance >= MAX_DISTANCE:
			beingPickedUp = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

func pickUpItem(body: CharacterBody2D) -> void:
	player = body
	beingPickedUp = true


