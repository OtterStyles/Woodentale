extends Panel

const ItemType = preload("res://Skripts/Inventory/Item.gd")
var ItemClass = preload("res://PreFab/Inventory/item.tscn")
var item = null


func initializeItem(item_name: String, item_quantity: int) -> void:
	if item == null:
		item = ItemClass.instantiate()
		item.setItem(item_name, item_quantity)
		add_child(item)
	else:
		item.setItem(item_name, item_quantity)

func pickFromSlot() -> void:
	remove_child(item)
	var inventoryNode  = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null

func putIntoSlot(new_item: ItemType) -> void:
	item = new_item
	item.position = Vector2.ZERO
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
