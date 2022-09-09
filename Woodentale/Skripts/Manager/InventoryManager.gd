extends Node
class_name InventoryManager

const COLUMN = 6
const ROW = 5
const NUM_INVENTORY_SLOTS = ROW * COLUMN
signal inventoryChanged

var inventory: Dictionary = {
	0: [DataEnums.ItemID.WOOD, 20],
	1: [DataEnums.ItemID.STONE, 5],
	2: [DataEnums.ItemID.FARN_HELMET, 1],
	3: [DataEnums.ItemID.FARN_CHEST, 1],
	4: [DataEnums.ItemID.FARN_PANTS, 1],
	5: [DataEnums.ItemID.FARN_SNEACKERS, 1],
	6: [DataEnums.ItemID.WOOD, 480],
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
	var ret = inventory.erase(slotIndex)
	inventoryChanged.emit()
	return ret
	
func addToSlot(item: ItemData, slotIndex: int) -> bool:
	if not inventory.has(slotIndex):
		inventory[slotIndex] = [item.itemID, item.item_quantity]
		inventoryChanged.emit()
		return true
	return false

func updateSlot(item: ItemData, slotIndex: int) -> bool:
	if inventory.has(slotIndex):
		if item == null:
			return removeSlot(slotIndex)
		if item.item_quantity <= 0:
			removeSlot(slotIndex)
		else:
			inventory[slotIndex] = [item.itemID, item.item_quantity]
		return true
	return false
