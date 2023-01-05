extends Control

var ItemClass = preload("res://PreFab/Inventory/item.tscn")
var itemData: ItemData = null

func updateItem(itemID: int, itemQuantity: int) -> void:
	var newItem: ItemData = ItemClass.instantiate()
	newItem.setItem(itemID, itemQuantity)
	if newItem != itemData:
		clearHotBarSlot()
		add_child(newItem)
		itemData = newItem
		setToolStamina()

func clearHotBarSlot() -> void:
	for child in get_children():
		remove_child(child)

func setHotbar(value: bool) -> void:
	if not itemData: return
	itemData.setHotbar(value)
	
func changeToolStamina(value: int) -> void:
	if not itemData: return
	itemData.changeToolStamina(value)

func setToolStamina():
	if not itemData: return
	itemData.setToolStamina(itemData.item.hasStamina, itemData.item.valueStamina)
