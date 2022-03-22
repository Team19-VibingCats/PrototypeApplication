extends Node2D

export var levelName = ""
var switched = false

func _on_PlayerDetectionArea_allPlayersPresent():
	if TokenHandler.host && !switched:
		switched = true
		call_deferred("switch")

func switch():
	GlobalConstants.switchLevel(levelName)
	FunctionCallHandler.requestFunctionCall(GlobalConstants,"switchLevel",levelName,true)
