extends Node

const NUM_INVENTORY_SLOTS = 30

var inventory = {
	0: [DataEnums.ItemID.WOOD, 10],
	1: [DataEnums.ItemID.STONE, 5],
	2: [DataEnums.ItemID.HELMET, 1]
}

func addItem(itemID: int, item_quantity: int) -> bool:
	var stackSize = ItemLoader.getItem(itemID).stackSize
	for item in inventory:
		if inventory[item][0] == itemID and inventory[item][1] + item_quantity <= stackSize:
			inventory[item][1]  += item_quantity
			return true
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [itemID, item_quantity]
			return true
	return false
