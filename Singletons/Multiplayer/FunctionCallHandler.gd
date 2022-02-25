extends Node

func requestFunctionCall(node,functionName,parameters = null,persistent = false):
	RequestHandler.requestSync(var2str({
		"type": "functionCall", 
		"nodePath": str(node.get_path()), 
		"functionName": functionName,
		"parameters": var2str(parameters)}), persistent)

func callFunction(path,functionName,paramString):
	var node = get_node_or_null(path)
	if node == null: return false
	
	var parameters = str2var(paramString)
	
	if parameters:
		node.call(functionName,parameters)
	else:
		node.call(functionName)
	
	return true
