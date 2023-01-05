extends Node
class_name ItemLoaderType

const path = "res://Resource/Items/"
var _itemDirectory = {}

func _init():
	var dir = Directory.new()
	if dir.open(path) == OK:
		for folder in dir.get_directories():
			var currentDir = Directory.new()
			if currentDir.open(path+folder) == OK:
				for file_name in currentDir.get_files():
					var res: ItemResource = load(path+folder+"/"+file_name)
					res.maxStamina = res.valueStamina
					if not _itemDirectory.has(res.itemID):
						res.stackSize = res.stackSizeFlags[res.stackSizeEnum].to_int()
						_itemDirectory[res.itemID] = res
					else:
						printerr("DUPLICATION: ID"+res.itemID+" is in "
						+res.itemName+ " and " + _itemDirectory.get(res.itemID).itemName)
	else:
		printerr("FAILED TO LOAD ITEMS")

func getItem(ID: int) -> ItemResource:
	if _itemDirectory.has(ID):
		return _itemDirectory[ID]
	return null

