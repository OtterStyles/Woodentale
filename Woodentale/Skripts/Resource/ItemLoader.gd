extends Node

const path = "res://Resource/Items/"
var itemDirectory = {}

func _init():
	var dir = Directory.new()
	var count = 0
	if dir.open(path) == OK:
		for file_name in dir.get_files():
			var res: ItemResource = load(path+file_name)
			itemDirectory[count] = res
	else:
		printerr("FAILED TO LOAD ITEMS")

func loadItems():
	return itemDirectory
