extends Node



func callFunction(path,functionName,parameters):
	var node = NodeTracker.getNode(path)
	if node == null: return
	
	node.call(functionName,parameters)
