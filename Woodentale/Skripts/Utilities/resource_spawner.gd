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
	print(map_to_local(cell))
	if randomSpawn():
		var newItemNode: ItemNode = itemNode.instantiate()
		newItemNode.health = activeSpawnNodes.health
		newItemNode.type = activeSpawnNodes.type
		newItemNode.itemDrops = activeSpawnNodes.itemDrops
		newItemNode.global_position = map_to_local(cell)
		get_parent().call_deferred("add_child", newItemNode)

func selectRandomSpawnNode() -> void:
	spawnNodes.shuffle()
	activeSpawnNodes = spawnNodes.front()

func randomSpawn() -> bool:
	return randf_range(0,1) <= activeSpawnNodes.spawnChance

