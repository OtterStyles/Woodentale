extends Control

const ItemType = preload("res://Skripts/Inventory/Item.gd")
var ItemClass = preload("res://PreFab/Inventory/item.tscn")
var item = null

func updateItem(item_id: int, item_quantity: int) -> void:
	var newItem = ItemClass.instantiate()
	newItem.setItem(item_id, item_quantity)
	if newItem != item:
		clear()
		add_child(newItem)
		item = newItem

func clear() -> void:
	for child in get_children():
		remove_child(child)
