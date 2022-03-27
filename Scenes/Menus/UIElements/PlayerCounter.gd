extends Node2D

func _ready():
	playerCountChanged(0)

func _enter_tree():
	GlobalVariables.registerPlayerCountListener(self)

func _exit_tree():
	GlobalVariables.deregisterPlayerCountListener(self)

func playerCountChanged(amount):
	if amount == 0: return
	$RichTextLabel.bbcode_text = "[center]"+str(amount)+" / "+ str(GlobalVariables.playerCount)
	$RichTextLabel.bbcode_text += " [img=20]res://Assets/Textures/UI/PlayerIcon.png[/img][/center]"
	
	if amount == GlobalVariables.playerCount:
		$AnimationPlayer.play("Fade")
