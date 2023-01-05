extends Area2D
class_name HutBox

@onready var collisionShape2D : CollisionShape2D = $CollisionShape2D
@onready var timer : Timer = $Timer
@export var invisibleTime : float = 0.5

func _ready() -> void:
	if invisibleTime > 0:
		timer.wait_time = invisibleTime


func _on_area_2d_area_entered(_area: Area2D) -> void:
	timer.start()
	if invisibleTime > 0:
		collisionShape2D.set_deferred('disabled', true)


func _on_timer_timeout() -> void:
	collisionShape2D.set_deferred('disabled', false)
