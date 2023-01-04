extends Node2D

@export var maxOverSize: int = 300

var canSpawnItems: bool = true
var itemQueue: Array[Array] = []

const ItemDrop = preload("res://PreFab/Inventory/itemDrop.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_children().size() < maxOverSize:
		canSpawnItems = true
		var headItemQueue = itemQueue.pop_front()
		if headItemQueue:
			_spawnItem(headItemQueue[0], headItemQueue[1])
	else:
		canSpawnItems = false

func addItemToQueue(itemDrop: ItemNodeDrops, localPosition):
	if not canSpawnItems:
		itemQueue.append([itemDrop, localPosition])
	else:
		_spawnItem(itemDrop, localPosition)

func _spawnItem(itemDrop, localPosition):
	var item = ItemDrop.instantiate()
	item.itemID = itemDrop.itemID
	item.global_position = localPosition
	item.velocity = randomVelocity()
	call_deferred("add_child" ,item)
	
func randomVelocity() -> Vector2:
	var maxRange = 200
	var minRange = -200
	return Vector2(randf_range(minRange,maxRange),randf_range(minRange,maxRange))
