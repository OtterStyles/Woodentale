extends TileMap
class_name ResourceSpawner

@export var spawnNodes: Array[Resource] = [] #SpawnFieldResource

var itemNode = load("res://PreFab/Utilities/itemnode.tscn")
var activeSpawnNodes: SpawnFieldResource
var initNodes = []

func _ready() -> void:
	initNodes = get_used_cells(0)
	visible = false

func _process(delta):
	if len(initNodes) > 0:
		for i in range(500):
			if len(initNodes) <= 0: return
			initItemNode(initNodes.pop_back())

func initItemNode(cell: Vector2i) -> void:
	selectRandomSpawnNode()
	if randomSpawn(): 
		var newItemNode: ItemNode = itemNode.instantiate()
		var newPosition = map_to_local(cell)
		newPosition.y += 15
		newItemNode.setHealths(activeSpawnNodes.healths)
		newItemNode.type = activeSpawnNodes.type
		newItemNode.itemNodeDrops = activeSpawnNodes.itemNodeDrops
		newItemNode.global_position = newPosition
		newItemNode.setItemID(activeSpawnNodes.itemID)
		newItemNode.changeSprite()
		get_parent().call_deferred("add_child", newItemNode)

func selectRandomSpawnNode() -> void:
	activeSpawnNodes = spawnNodes[randi_range(0,len(spawnNodes) - 1)]

func randomSpawn() -> bool:
	return randi_range(0,1) <= activeSpawnNodes.spawnChance

