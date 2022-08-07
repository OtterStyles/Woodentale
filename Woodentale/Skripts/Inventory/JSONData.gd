extends Node

var item_data: Dictionary

func _ready():
	item_data = LoadData("res://Data/Items/ItemData.json")


func LoadData(file_path: String):
	var json_data = JSON.new()
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data.parse(file_data.get_as_text())
	return json_data.get_data()
