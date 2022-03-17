extends Node

export(NodePath) var nodePath
export var propertyPath = ""
export var interpolate = false
export var interpolateSpeed = 1.0
export var persistent = false
export var alwaysSynchronize = false

var waitingForSync = false
var actualNode

var globalPath = ""

func _ready():
	actualNode = get_node(nodePath)
	
	if alwaysSynchronize:
		$ProcessManager.free()
		set_process(true)

func _process(delta):
	synchronize()

func startSynchronize():
	set_process(true)

func stopSynchronize():
	set_process(false)

func forceSynchronize(forceInterpolate = false):
	var previousInterpolate = interpolate
	interpolate = forceInterpolate
	synchronize(true)
	interpolate = previousInterpolate

func synchronize(forced = false):
	if !validNode() || (waitingForSync && !forced): return
	
	waitingForSync = true
	
	var newValue = actualNode.get(propertyPath)
	RequestHandler.requestSync(var2str({
		"type": "setProperty", 
		"nodePath": str(actualNode.get_path()), 
		"propertyPath": propertyPath, 
		"value": newValue,
		"interpolate": interpolate,
		"interpolateSpeed": interpolateSpeed}), persistent, self)

func validNode():
	if is_instance_valid(actualNode):
		return true
	else:
		queue_free()
		set_process(false)
		return false
