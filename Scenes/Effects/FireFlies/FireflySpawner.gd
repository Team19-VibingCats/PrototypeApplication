extends Node2D

export var spawnRate = 1.0

var flyScene = preload("res://Scenes/Effects/FireFlies/FireFly.tscn")

var timer = 0.0

func _process(delta):
	timer += delta
	
	if timer > 1.0/spawnRate:
		timer = 0.0
		spawnFireFly()

func spawnFireFly():
	var fly = flyScene.instance()
	
	fly.position.x = rand_range(-10,10)*scale.x + global_position.x
	fly.position.y = rand_range(-10,10)*scale.y + global_position.y
	
	get_tree().current_scene.add_child(fly)
