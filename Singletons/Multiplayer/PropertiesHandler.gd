extends Node

var interpolatedProperties = {}

func requestPropertySync(node,propertyPath, value, interpolate, persistent = false, interpolateSpeed = 0.0):
	RequestHandler.requestSync(var2str({
		"type": "setProperty", 
		"nodePath": str(node.get_path()), 
		"propertyPath": propertyPath, 
		"value": value,
		"interpolate": interpolate,
		"interpolateSpeed": interpolateSpeed}), persistent)

func setProperty(nodePath, propertyPath, value, interpolated, interpolateSpeed = 0.0):
	var node = get_node_or_null(nodePath)
	if node == null: return
	
	if interpolated:
		interpolatedProperties[nodePath+propertyPath] = [node,propertyPath,node.get(propertyPath),value,0.0,interpolateSpeed]
	else:
		node.set(propertyPath,value)

func _process(delta):
	var finishedProperties = []
	
	for id in interpolatedProperties:
		var data = interpolatedProperties[id]
		
		if(!is_instance_valid(data[0])):
			finishedProperties.append(id)
			continue
		
		var startValue = data[2]
		var newValue = data[3]
		data[4] = clamp(data[4]+delta*data[5],0,1)
		data[0].set(data[1],lerp(startValue,newValue,data[4]))
		
		if data[4] >= 1: finishedProperties.append(id)
	
	for id in finishedProperties:
		interpolatedProperties.erase(id)
