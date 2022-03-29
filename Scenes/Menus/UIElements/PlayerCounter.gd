extends Node2D

var lastAmount = 0

func _ready():
	playerCountChanged(0)

func _enter_tree():
	GlobalVariables.registerPlayerCountListener(self)

func _exit_tree():
	GlobalVariables.deregisterPlayerCountListener(self)

func playerCountChanged(amount):
	lastAmount = amount
	$RichTextLabel.bbcode_text = "[center]"+str(amount)+" / "+ str(GlobalVariables.playerCount)
	$RichTextLabel.bbcode_text += " [img=20]res://Assets/Textures/UI/PlayerIcon.png[/img][/center]"
	
	if amount == GlobalVariables.playerCount:
		$AnimationPlayer.play("Fade")

func maxPlayerCountChanged():
	$RichTextLabel.bbcode_text = "[center]"+str(lastAmount)+" / "+ str(GlobalVariables.playerCount)
	$RichTextLabel.bbcode_text += " [img=20]res://Assets/Textures/UI/PlayerIcon.png[/img][/center]"
