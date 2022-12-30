extends TileMap
@export var spawnNodes: Array[Resource] = []
var itemNode = load("res://PreFab/Utilities/itemnode.tscn")
var activeSpawnNodes: SpawnFieldResource


func _ready():
	for cell in get_used_cells(0):
		initItemNode(cell)
	visible = false
	
func initItemNode(cell: Vector2i) -> void:
	selectRandomSpawnNode()
	if randomSpawn():
		var newItemNode: ItemNode = itemNode.instantiate()
		newItemNode.setHealths(activeSpawnNodes.healths)
		newItemNode.type = activeSpawnNodes.type
		newItemNode.itemDrops = activeSpawnNodes.itemDrops
		var newPosition = map_to_local(cell)
		newPosition.y += 15
		newItemNode.global_position = newPosition
		newItemNode.setItemID(activeSpawnNodes.itemID)
		newItemNode.changeSprite()
		get_parent().call_deferred("add_child", newItemNode)

func selectRandomSpawnNode() -> void:
	activeSpawnNodes = spawnNodes[randi_range(0,len(spawnNodes) - 1)]

func randomSpawn() -> bool:
	return randi_range(0,1) <= activeSpawnNodes.spawnChance

