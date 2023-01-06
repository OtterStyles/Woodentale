extends TileMap
class_name FarmGroundSpawner

var farmNode = preload("res://PreFab/Utilities/farm_node.tscn")
var initNodes = []

func _ready() -> void:
	initNodes = get_used_cells(0)
	visible = false

func _process(delta):
	if len(initNodes) > 0:
		for i in range(500):
			if len(initNodes) <= 0: return
			var newFarmNode = farmNode.instantiate()
			var cell = initNodes.pop_back()
			newFarmNode.global_position = map_to_local(cell)
			get_parent().call_deferred("add_child", newFarmNode)
