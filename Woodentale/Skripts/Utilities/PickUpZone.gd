extends Area2D


var itemsInRange = {}

func _on_pick_up_zone_body_entered(body: CharacterBody2D) -> void:
	print(body)
	itemsInRange[body] = body

func _on_pick_up_zone_body_exited(body: CharacterBody2D) -> void:
	if itemsInRange.has(body):
		itemsInRange.erase(body)
