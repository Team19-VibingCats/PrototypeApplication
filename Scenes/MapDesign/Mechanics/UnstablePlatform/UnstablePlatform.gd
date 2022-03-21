extends Node2D

export var breakTime = 5.0
export var respawnTime = 10.0
export(Array, NodePath) var spritePaths
var sprites = []

var timer = 0.0
var currentIndex = 0
var destroyed = false

var playerCount = 0

func _ready():
	for path in spritePaths:
		sprites.append(get_node(path))
	
	setSprite(0)

func _physics_process(delta):
	if !TokenHandler.host: return
	
	if playerCount > 0 || destroyed:
		timer += delta
		
		if !destroyed:
			var newIndex = floor((timer/breakTime)*sprites.size())
			
			if newIndex != currentIndex:
				setSprite(newIndex)
				FunctionCallHandler.requestFunctionCall(self,"setSprite",newIndex,false)
				
				if newIndex == sprites.size():
					destroy()
					FunctionCallHandler.requestFunctionCall(self,"destroy")
			
		else:
			if timer > respawnTime:
				respawn()
				FunctionCallHandler.requestFunctionCall(self,"respawn")

func setSprite(i):
	currentIndex = i
	
	for index in range(sprites.size()):
		var sprite = sprites[index]
		sprite.visible = index == i

func destroy():
	$StaticBody2D/CollisionShape2D.disabled = true
	destroyed = true
	timer = 0.0
	
	setSprite(null)

func respawn():
	$StaticBody2D/CollisionShape2D.disabled = false
	destroyed = false
	timer = 0.0
	
	setSprite(0)

func _on_PlayerDetectionArea_playerCountChanged(amount):
	playerCount = amount
