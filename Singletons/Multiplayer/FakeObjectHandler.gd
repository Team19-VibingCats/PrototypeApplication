extends Node

var player = preload("res://Scenes/Characters/Player/FakePlayer.tscn")

func instanceObject(data):
	var objectInstance = get(data["instance"]).instance()
	get_tree().current_scene.add_child(objectInstance)
	objectInstance.name = data["name"]
