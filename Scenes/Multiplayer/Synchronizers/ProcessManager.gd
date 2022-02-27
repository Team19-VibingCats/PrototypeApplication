extends Node

export(NodePath) var node
export var disableWhenClient = true
export var disableWhenHost = false

var actualNode

func _enter_tree():
	actualNode = get_node(node)
	
	if is_instance_valid(actualNode):
		TokenHandler.synchronizers.append(self)
		statusUpdated()
	else:
		queue_free()

func statusUpdated():
	if TokenHandler.host:
		actualNode.set_process(!disableWhenHost)
		actualNode.set_physics_process(!disableWhenHost)
	else:
		actualNode.set_process(!disableWhenClient)
		actualNode.set_physics_process(!disableWhenClient)

func _exit_tree():
	if TokenHandler.synchronizers.has(self): TokenHandler.synchronizers.erase(self)
