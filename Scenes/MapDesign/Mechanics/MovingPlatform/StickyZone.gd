extends Node2D

var players = []

var lastPosition = global_position

func _physics_process(delta):
	var diff = global_position-lastPosition
	
	for player in players:
		if is_instance_valid(player):
			player.position += diff
	
	lastPosition = global_position

func _on_PlayerDetectionArea_playerEntered(player):
	players.append(player)

func _on_PlayerDetectionArea_playerExited(player):
	players.erase(player)
