extends Node
class_name SpawnOutlet

signal addNode
signal addItem

var addNodeQueue = []

func _process(delta):
	for i in range(1000):
		if len(addNodeQueue) <= 0: return
		addNode.emit(addNodeQueue.pop_front())

func addNewNode(toSpawnNode):
	addNodeQueue.append(toSpawnNode)

func addNewItem(toSpawnItem, spawnPosition):
	addItem.emit(toSpawnItem, spawnPosition)
