extends Node

@onready var pickupZone = %PickUpZone
@onready var player = $"../.."


func _process(delta: float) -> void:
	if pickupZone.itemsInRange.size() > 0:
		var pickupItem = pickupZone.itemsInRange.values()[0]
		pickupItem.pickUpItem(player)
		pickupZone.itemsInRange.erase(pickupItem)
