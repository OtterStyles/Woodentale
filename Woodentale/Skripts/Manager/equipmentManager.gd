extends Node

@onready var player = $"../.."
var pivots

func _process(_delta):
	pivots = player.pivot_manager.pivotPositions



