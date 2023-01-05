extends Area2D
class_name PickUpZone

var itemsInRange = {}

func _on_pick_up_zone_body_entered(body: CharacterBody2D) -> void:
	itemsInRange[body] = body

func _on_pick_up_zone_body_exited(body: CharacterBody2D) -> void:
	if itemsInRange.has(body):
		itemsInRange.erase(body)
