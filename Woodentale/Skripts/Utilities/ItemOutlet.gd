extends Node2D
class_name ItemOutlet

@export var maxOverSize: int = 300

var canSpawnItems: bool = true
var itemQueue: Array[Array] = []

const ItemDropType = preload("res://PreFab/Inventory/itemDrop.tscn")


func _process(_delta: float) -> void:
	if get_children().size() < maxOverSize:
		canSpawnItems = true
		var headItemQueue = itemQueue.pop_front()
		if headItemQueue:
			_spawnItem(headItemQueue[0], headItemQueue[1])
	else:
		canSpawnItems = false

func addItemToQueue(itemDrop: ItemNodeDrop, localPosition: Vector2) -> void:
	if not canSpawnItems:
		itemQueue.append([itemDrop, localPosition])
	else:
		_spawnItem(itemDrop, localPosition)

func _spawnItem(itemDrop: ItemNodeDrop, localPosition: Vector2) -> void:
	var item = ItemDropType.instantiate()
	item.itemID = itemDrop.itemID
	item.global_position = localPosition
	item.velocity = _randomVelocity()
	call_deferred("add_child" ,item)
	
func _randomVelocity() -> Vector2:
	var maxRange = 200
	var minRange = -200
	return Vector2(randf_range(minRange,maxRange),randf_range(minRange,maxRange))
