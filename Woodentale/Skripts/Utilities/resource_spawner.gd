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
		$"../ItemOutlet".addItemToQueue(activeSpawnNodes,map_to_local(cell) )

func selectRandomSpawnNode() -> void:
	activeSpawnNodes = spawnNodes[randi_range(0,len(spawnNodes) - 1)]

func randomSpawn() -> bool:
	return randi_range(0,1) <= activeSpawnNodes.spawnChance

