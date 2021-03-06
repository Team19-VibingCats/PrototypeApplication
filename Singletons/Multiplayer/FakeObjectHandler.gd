extends Node

var player = preload("res://Scenes/Characters/Player/FakePlayer.tscn")
var rope = preload("res://Scenes/MapDesign/Mechanics/GrapplingRope/FakeGrapplingRope.tscn")

func instanceObject(data):
	if data["name"] == TokenHandler.username: return
	
	var objectInstance = get(data["instance"]).instance()
	objectInstance.name = data["name"]
	get_tree().current_scene.add_child(objectInstance)

func removeFakeObject(nodePath):
	var node = get_node(nodePath)
	if node == null || node.name == TokenHandler.username: return
	
	GlobalFunctions.removeAndFree(node)
