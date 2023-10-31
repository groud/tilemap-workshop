####################################################################################################
# --- character_2D.gd ---  
# 
# Display 2D character in a 2D world with 3D coordinates. The third dimension is handled using
# Y-sort coordinates.
####################################################################################################
extends Node2D

func set_3D_position(value):
	global_position = Vector2(value.x, value.z)
	$Sprite2D.position = Vector2(0, -round(value.y))

func _on_character_3d_position_changed(pos):
	set_3D_position(pos * 16)
