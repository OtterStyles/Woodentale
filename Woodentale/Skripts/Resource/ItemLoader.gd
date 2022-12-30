extends Node

const path = "res://Resource/Items/"
var itemDirectory = {}

func _init():
	var dir = Directory.new()
	if dir.open(path) == OK:
		for folder in dir.get_directories():
			var currentDir = Directory.new()
			if currentDir.open(path+folder) == OK:
				for file_name in currentDir.get_files():
					var res: ItemResource = load(path+folder+"/"+file_name)
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
	return ERR_DOES_NOT_EXIST

