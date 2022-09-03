extends Area2D

@onready var collisionShape2D : CollisionShape2D = $CollisionShape2D
@onready var timer : Timer = $Timer
@export var invisibleTime : float = 0.5

func _ready() -> void:
	timer.wait_time = invisibleTime


func _on_area_2d_area_entered(_area: Area2D) -> void:
	timer.start()
	collisionShape2D.set_deferred('disabled', true)


func _on_timer_timeout() -> void:
	collisionShape2D.set_deferred('disabled', false)
