extends StaticBody2D

var offset = 0

func _process(delta):
	var bodies = $Area2D.get_overlapping_bodies()
	var jumping = false
	for body in bodies:
		if body.name == "Character2D":
			jumping = true

	if jumping:
		$Blacksmith.position.y = -abs(sin((Time.get_ticks_msec() - offset) / 100.0)) * 16
	else:
		$Blacksmith.position.y = 0
		offset = Time.get_ticks_msec()
