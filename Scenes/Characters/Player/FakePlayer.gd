extends KinematicBody2D

export(Array,NodePath) var characterSpritePaths
var characterSprites = []

var externalVelocity = Vector2(0,0)
var connectedByRope = false

func _ready():
	for spritePath in characterSpritePaths:
		characterSprites.append(get_node(spritePath))
		get_node(spritePath).frame = 0

func _enter_tree():
	GlobalVariables.playerCount += 1
	GlobalVariables.fakePlayers.append(get_parent())

func _exit_tree():
	GlobalVariables.playerCount -= 1
	GlobalVariables.fakePlayers.erase(get_parent())


#Sprite handling------------------------------------------------------------------------------------
var animationBlocked = false
func playAnimation(animationData):
	if animationBlocked: return
	
	for sprite in characterSprites:
		if animationData["Reset"]: sprite.stop()
		sprite.play(animationData["Animation"])
	
	if animationData["Block"]:
		animationBlocked = true

func _on_AnimatedSprite_animation_finished():
	animationBlocked = false

func playSpinParticles():
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
