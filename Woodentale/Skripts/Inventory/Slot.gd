extends Panel

@export_category("Type")
@export var mainType: DataEnums.MainType = DataEnums.MainType.ITEM
@export var itemType: DataEnums.ItemType = DataEnums.ItemType.RESOURCE
@export var itemSubType: DataEnums.SubItemType = DataEnums.SubItemType.NONE

const ItemType = preload("res://Skripts/Inventory/Item.gd")
var ItemClass = preload("res://PreFab/Inventory/item.tscn")
var item = null

func initializeItem(item_id: int, item_quantity: int) -> void:
	if item == null:
		item = ItemClass.instantiate()
		item.setItem(item_id, item_quantity)
		add_child(item)
	else:
		item.setItem(item_id, item_quantity)

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
