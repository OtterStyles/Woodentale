extends Node
@onready var player = $".."



func _ready():
	if not AllPlayerManager.players.has(player.name):
		var managers = getAllManagers()
		for manager in managers:
			AllPlayerManager.players[player.name] =  {}
			AllPlayerManager.players[player.name][manager.name] = manager
			
func getAllManagers():
	return get_children()
