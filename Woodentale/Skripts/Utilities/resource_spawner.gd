extends TileMap
@export var spawnNodes: Array[Resource] = []
var itemNode = load("res://PreFab/Utilities/itemnode.tscn")
var activeSpawnNodes: SpawnFieldResource
# Called when the node enters the scene tree for the first time.
func _ready():
	for cell in get_used_cells(0):
		initItemNode(cell)
	visible = false
	
func initItemNode(cell: Vector2i) -> void:
	selectRandomSpawnNode()
	if randomSpawn():
		var newItemNode: ItemNode = itemNode.instantiate()
		newItemNode.healths = activeSpawnNodes.healths
		newItemNode.type = activeSpawnNodes.type
		newItemNode.itemDrops = activeSpawnNodes.itemDrops
		newItemNode.global_position = map_to_local(cell)
		newItemNode.setItemID(activeSpawnNodes.itemID)
		newItemNode.changeSprite()
		get_parent().call_deferred("add_child", newItemNode)

func selectRandomSpawnNode() -> void:
	activeSpawnNodes = spawnNodes[randi_range(0,len(spawnNodes) - 1)]

func randomSpawn() -> bool:
	return randi_range(0,1) <= activeSpawnNodes.spawnChance

