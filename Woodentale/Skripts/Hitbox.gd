extends Area2D

@onready var collisionShape2D : CollisionShape2D = $CollisionShape2D



func _on_hitbox_area_entered(area):
	print(area)
