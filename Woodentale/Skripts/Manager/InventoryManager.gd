extends Node
class_name InventoryManager

const NUM_INVENTORY_SLOTS = 30
signal inventoryChanged

var inventory: Dictionary = {
	0: [DataEnums.ItemID.WOOD, 10],
	1: [DataEnums.ItemID.STONE, 5],
	2: [DataEnums.ItemID.HELMET, 1]
}


func addItem(itemID: int, item_quantity: int) -> bool:
	var stackSize = ItemLoader.getItem(itemID).stackSize
	for item in inventory.values():
		if item[0] == itemID and item[1] < stackSize:
			item[1] += item_quantity
			inventoryChanged.emit()
			return true
	for i in range(NUM_INVENTORY_SLOTS):
		if not inventory.has(i):
			inventory[i] = [itemID, item_quantity]
			inventoryChanged.emit()
			return true
	return false

func removeSlot(slotIndex: int) -> bool:
	inventoryChanged.emit()
	return inventory.erase(slotIndex)
	
func addToSlot(item: ItemData, slotIndex: int) -> bool:
	if not inventory.has(slotIndex):
		inventoryChanged.emit()
		inventory[slotIndex] = [item.itemID, item.item_quantity]
		return true
	return false
