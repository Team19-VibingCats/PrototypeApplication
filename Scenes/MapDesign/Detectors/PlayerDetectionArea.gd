extends Area2D

signal playerCountChanged(amount)
signal allPlayersPresent

var playersInArea = 0

func _on_PlayerDetectionArea_body_entered(body):
	playersInArea += 1
	
	emit_signal("playerCountChanged",playersInArea)
	if playersInArea == GlobalVariables.playerCount:
		emit_signal("allPlayersPresent")

func _on_PlayerDetectionArea_body_exited(body):
	playersInArea -= 1
	
	emit_signal("playerCountChanged",playersInArea)
