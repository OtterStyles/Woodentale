extends Node
class_name PivotManager
@onready var player = $"../.."
@onready var pivots = $"../../Pivots"

var _pivotPositions = {}

func _process(_delta: float) -> void:
	for pivot in pivots.get_children():
		_pivotPositions[pivot.name] = player.global_position + pivot.position

func getPivotByName(name: String) -> Vector2:
	if _pivotPositions.has(name):
		return _pivotPositions[name]
	return Vector2.ZERO

func getAllPivots() -> Dictionary:
	return _pivotPositions
