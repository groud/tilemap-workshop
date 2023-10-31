####################################################################################################
# --- character_3D.gd ---  
# 
# A simple character 3D controller with signal to notify its position changed.
####################################################################################################
extends CharacterBody3D

@export var remote : NodePath

signal position_changed(pos: Vector3)

const HORIZONTAL_SPEED = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Compute horizontal speed
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var h_velocity = Vector3(input_vector.x, 0, input_vector.y)
	h_velocity *= HORIZONTAL_SPEED
	velocity = h_velocity + Vector3(h_velocity.x, velocity.y, h_velocity.z)

	if is_on_floor():
		# Jump
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y += 15
	else:
		# Gravity
		velocity.y -= 80 * delta
		velocity.y = max(-10, velocity.y)

	# Move
	move_and_slide()

	# Synchronize position
	position_changed.emit(Vector3(global_position.x, global_position.y, global_position.z))
