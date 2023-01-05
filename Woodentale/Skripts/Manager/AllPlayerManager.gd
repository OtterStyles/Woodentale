extends Node

var _players: Dictionary =  {}

func addPlayer(manager: ManagerClass) -> void:
	if not _players.has(manager.player.name):
		_players[manager.player.name] = manager

func getManagerByPlayer(player: Player) -> ManagerClass:
	if _players.has(player.name):
		return _players[player.name]
	return null
