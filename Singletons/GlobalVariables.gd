extends Node

var playerNames = []
var playerCount = 1 setget playerCountChanged
var playerCountListeners = []

var fakePlayers = []

var initialPlayerSync = false

func playerCountChanged(amount):
	playerCount = amount
	
	for listener in playerCountListeners:
		listener.maxPlayerCountChanged()

func registerPlayerCountListener(listener):
	playerCountListeners.append(listener)

func deregisterPlayerCountListener(listener):
	playerCountListeners.erase(listener)
