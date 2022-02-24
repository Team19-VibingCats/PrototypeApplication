extends Node

export(NodePath) var nodePath
export var propertyPath = ""
export var persistent = false

var waitingForSync = false
var actualNode


func _ready():
	actualNode = get_node(nodePath)

func _process(delta):
	synchronize()

func startSynchronize():
	set_process(true)

func stopSynchronize():
	set_process(false)

func synchronize():
	if !validNode() || waitingForSync: return
	
	waitingForSync = true
	
	var newValue = actualNode.get(propertyPath)
	RequestHandler.requestSync(var2str({
		"type": "setProperty", 
		"nodePath": nodePath, 
		"propertyPath": propertyPath, 
		"value": newValue}), persistent, self)

func validNode():
	if is_instance_valid(actualNode):
		return true
	else:
		queue_free()
		set_process(false)
		return false
