extends Node2D

export var breakTime = 5.0
export var respawnTime = 10.0
export(Array, NodePath) var spritePaths
export(Array, NodePath) var particlePaths
var sprites = []
var particles = []

var timer = 0.0
var currentIndex = 0
var destroyed = false

var playerCount = 0

var particleTimer = 0.0

func _ready():
	set_process(false)
	
	for path in spritePaths:
		sprites.append(get_node(path))
	
	for path in particlePaths:
		particles.append(get_node(path))
	
	setSprite(0)

func _process(delta):
	particleTimer += delta
	
	if particleTimer < 0.1:
		emitParticles()
	else:
		set_process(false)
		stopParticles()
		particleTimer = 0.0

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
	
	if i != 0: set_process(true)
	
	for index in range(sprites.size()):
		var sprite = sprites[index]
		sprite.visible = index == i

func emitParticles():
	for particle in particles:
		particle.emitting = true

func stopParticles():
	for particle in particles:
		particle.emitting = false

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
