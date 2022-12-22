extends Node

@onready var player = $"../.."
var pivots

func _process(delta):
	pivots = player.pivot_manager.pivotPositions



