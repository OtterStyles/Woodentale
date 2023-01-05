extends Node
class_name EquipmentManager

@onready var player = $"../.."
var pivots

func _process(_delta) -> void:
	pivots = player.pivot_manager.getAllPivots()

