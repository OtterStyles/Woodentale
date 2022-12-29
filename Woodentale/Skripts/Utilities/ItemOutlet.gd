extends Node2D

@export var maxOverSize: int = 300

var canSpawnItems: bool = true
var itemQueue: Array[Dictionary] = []
var itemNode = load("res://PreFab/Utilities/itemnode.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_children().size() < maxOverSize:
		_spawnItem(itemQueue.pop_front()['Node'], itemQueue.pop_front()['Position'])
		maxOverSize = true
	else:
		maxOverSize = false
		
		
		
func addItemToQueue(activeSpawnNodes: SpawnFieldResource, designetedPosition: Vector2):
	if canSpawnItems:
		itemQueue.append({'Node': activeSpawnNodes, 'Position': designetedPosition})
	
		
func _spawnItem(activeSpawnNodes, designetedPosition):
	var newItemNode: ItemNode = itemNode.instantiate()
	newItemNode.healths = activeSpawnNodes.healths
	newItemNode.type = activeSpawnNodes.type
	newItemNode.itemDrops = activeSpawnNodes.itemDrops
	newItemNode.global_position = designetedPosition
	newItemNode.global_position.y = newItemNode.global_position.y + 15
	newItemNode.setItemID(activeSpawnNodes.itemID)
	newItemNode.changeSprite()
	add_child(newItemNode)
