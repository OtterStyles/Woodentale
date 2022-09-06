extends Node

var players: Dictionary =  {}

func addPlayer(manager: ManagerClass):
	if not players.has(manager.player.name):
		players[manager.player.name] = manager
