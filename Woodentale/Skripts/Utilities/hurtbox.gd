extends Area2D

@onready var collisionShape2D : CollisionShape2D = $CollisionShape2D
@onready var timer : Timer = $Timer
@export var invisibleTime : float = 0.5

func _ready():
	timer.wait_time = invisibleTime


func _on_area_2d_area_entered(area):
	timer.start()
	print(typeof(area))
	collisionShape2D.set_deferred('disabled', true)


func _on_timer_timeout():
	collisionShape2D.set_deferred('disabled', false)
