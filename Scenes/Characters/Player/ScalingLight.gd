extends Light2D

var targetScale = 0.0

func _process(delta):
	texture_scale = lerp(texture_scale,targetScale,delta*2)

func _on_PlayerDetectionArea_playerCountChanged(amount):
	var effectiveness = 1
	
	targetScale = 0.2
	amount -= 1
	
	for i in amount:
		targetScale += 0.3*effectiveness
		effectiveness *= 0.7
