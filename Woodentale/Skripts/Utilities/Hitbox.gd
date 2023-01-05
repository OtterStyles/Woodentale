extends Area2D
class_name HitBox

@onready var collisionShape2D : CollisionShape2D = $CollisionShape2D

func _on_hitbox_area_entered(area: Area2D) -> void:
	print(area)
