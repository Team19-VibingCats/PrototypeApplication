extends Node2D

func _ready():
	AudioServer.set_bus_layout(load("res://default_bus_layout.tres"))
