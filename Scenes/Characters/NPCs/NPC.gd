extends Node2D

export var dialogName = ""

func _on_PlayerDetectionArea_allPlayersPresent():
	var dialogue = Dialogic.start(dialogName)
	add_child(dialogue)
	
	GlobalConstants.controlsDisabled = true
	dialogue.connect("timeline_end",self,"dialogueFinished")

func dialogueFinished(timelineName):
	GlobalConstants.controlsDisabled = false
	
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("Remove")
