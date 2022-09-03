extends Node

const NUM_INVENTORY_SLOTS = 35

var inventory = {
	0: ["Squisch Blue", 10],
	1: ["Squisch Red", 5],
	2: ["Squisch Green", 1],
	6: ["Squisch Head", 1]
}

func addItem(item_name: String, item_quantity: int) -> bool:
	for item in inventory:
		if inventory[item][0] == item_name:
			inventory[item][1]  += item_quantity
			return true
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return true
	return false
