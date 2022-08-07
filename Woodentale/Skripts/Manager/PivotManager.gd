extends Node

@onready var player = $"../.."
@onready var pivots = $"../../Pivots"

var pivotPositions = {}

func _process(delta):
	for pivot in pivots.get_children():
		pivotPositions[pivot.name] = player.global_position + pivot.position
