extends Node2D

func _ready():
	playerCountChanged(0)

func playerCountChanged(amount):
	$RichTextLabel.bbcode_text = "[center]"+str(amount)+" / "+ str(GlobalVariables.playerCount)
	$RichTextLabel.bbcode_text += " [img=20]res://Assets/Textures/UI/PlayerIcon.png[/img][/center]"
	
	if amount == GlobalVariables.playerCount:
		$AnimationPlayer.play("Fade")
