extends Node2D

var playersInArea = []

var ropeScene = preload("res://Scenes/MapDesign/Mechanics/Rope/Rope.tscn")

func _on_PlayerDetectionArea_playerEntered(player):
	playersInArea.append(player)
	attachPlayers()

func _on_PlayerDetectionArea_playerExited(player):
	playersInArea.erase(player)

func attachPlayers():
	var playersWithoutRope = []
	for player in playersInArea:
		if !player.connectedByRope && is_instance_valid(player):
			playersWithoutRope.append(player)
	
	while playersWithoutRope.size() >= 2:
		var player1 = playersWithoutRope[0]
		var player2 = playersWithoutRope[1]
		playersWithoutRope.erase(player1)
		playersWithoutRope.erase(player2)
		
		var rope = ropeScene.instance()
		get_tree().current_scene.add_child(rope)
		rope.connectRope(player1,player2)
