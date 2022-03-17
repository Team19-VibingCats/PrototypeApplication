extends Node

func reparentNode(node, newParent):
	var oldParent = node.get_parent()
	if oldParent == null:
		newParent.add_child(node)
	else:
		oldParent.remove_child(node)
		newParent.add_child(node)
		
		if node.get_parent() != newParent:
			newParent.call_deferred("add_child",node)

func unparentNode(node):
	var parent = node.get_parent()
	if parent != null:
		parent.remove_child(node)

func removeAndFree(node):
	unparentNode(node)
	node.queue_free()
