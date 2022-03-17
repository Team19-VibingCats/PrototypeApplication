extends KinematicBody2D

export(NodePath) var characterSprite

func _ready():
	characterSprite = get_node(characterSprite)

func _enter_tree():
	GlobalVariables.playerCount += 1

func _exit_tree():
	GlobalVariables.playerCount -= 1


#Sprite handling------------------------------------------------------------------------------------
var animationBlocked = false
func playAnimation(animationData):
	if animationBlocked: return
	
	if animationData["Reset"]: characterSprite.stop()
	characterSprite.play(animationData["Animation"])
	
	if animationData["Block"]:
		animationBlocked = true

func _on_AnimatedSprite_animation_finished():
	animationBlocked = false
