extends Node2D

export var dialogName = ""

var active = true

func _on_PlayerDetectionArea_allPlayersPresent():
	if !active: return
	active = false
	
	var dialogue = Dialogic.start(dialogName)
	add_child(dialogue)
	
	GlobalConstants.controlsDisabled = true
	dialogue.connect("timeline_end",self,"dialogueFinished")

func dialogueFinished(timelineName):
	GlobalConstants.controlsDisabled = false
	
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("Remove")
