extends Node

var serverAddress = "http://134.122.50.55:8080/MultiplayerServer-prototype-1"
#var serverAddress = "http://localhost:8080/Java_Multiplayer_Server_war"

var controlsDisabled = false

var level1 = load("res://Scenes/Main/Level_1.tscn")
var level2 = load("res://Scenes/Main/Level_2.tscn")

func switchLevel(level):
	var newLevel = get(level).instance()
	
	for player in GlobalVariables.fakePlayers:
		GlobalFunctions.call_deferred("reparentNode",player,newLevel)
	
	var oldScene = get_tree().current_scene
	get_tree().root.add_child(newLevel)
	get_tree().current_scene = newLevel
	GlobalFunctions.unparentNode(oldScene)
	
	newLevel.name = "CurrentScene"
