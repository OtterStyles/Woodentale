extends TileMap
class_name FarmGroundSpawner

var farmNode = preload("res://PreFab/Utilities/farm_node.tscn")

func _ready() -> void:
	for cell in get_used_cells(0):
		var newFarmNode = farmNode.instantiate()
		newFarmNode.global_position = map_to_local(cell)
		get_parent().call_deferred("add_child", newFarmNode)
	visible = false

