extends Node2D
class_name ResourceSpawnPoint

var positionNodes: Array = []

func _ready():
	SpawnOutletManager.addNode.connect(addNode)

func addNode(node):
	if not [node.position, node.name] in positionNodes:
		positionNodes.append([node.position, node.name])
		call_deferred("add_child", node)
