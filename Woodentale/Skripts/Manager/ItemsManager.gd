extends Node

@onready var pickupZone = %PickUpZone
@onready var player = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pickupZone.itemsInRange.size() > 0:
		var pickupItem = pickupZone.itemsInRange.values()[0]
		pickupItem.pickUpItem(player)
		pickupZone.itemsInRange.erase(pickupItem)
		
