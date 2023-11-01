####################################################################################################
# --- character_2D.gd ---  
# 
# A simple character 3D controller with signal to notify its position changed.
####################################################################################################
extends CharacterBody2D

const HORIZONTAL_SPEED = 10 * 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Compute horizontal speed
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * HORIZONTAL_SPEED

	# H Flip
	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x < 0

	# Move
	move_and_slide()
