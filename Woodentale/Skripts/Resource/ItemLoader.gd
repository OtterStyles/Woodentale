extends Node

const path = "res://Resource/Items/"
var itemDirectory = {}

func _init():
	var dir = Directory.new()
	if dir.open(path) == OK:
		for file_name in dir.get_files():
			var res: ItemResource = load(path+file_name)
			if not itemDirectory.has(res.itemID):
				res.stackSize = res.stackSizeFlags[res.stackSizeEnum].to_int()
				itemDirectory[res.itemID] = res
			else:
				printerr("DUPLICATION: ID"+res.itemID+" is in "
				+res.itemName+" and "+itemDirectory.get(res.itemID).itemName)
	else:
		printerr("FAILED TO LOAD ITEMS")

func getItem(ID: int):
	if itemDirectory.has(ID):
		return itemDirectory[ID]
	return null

