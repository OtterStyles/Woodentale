extends Panel

var Itemclass = preload("res://PreFab/Inventory/item.tscn")
var item = null


func _ready():
	if randi() % 2 == 0:
		item = Itemclass.instantiate()
		add_child(item)



func pickFromSlot():
	remove_child(item)
	var inventoryNode  = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
