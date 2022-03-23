tool
extends Node2D

func _ready():
	if !Engine.editor_hint: return
	
	var randomChild = floor(rand_range(0,get_child_count()))
	
	for i in range(get_child_count()):
		var child = get_child(i)
		child.visible = i == randomChild
