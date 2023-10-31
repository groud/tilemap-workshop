####################################################################################################
# --- debug_camera.gd ---  
# 
# This debug camera will spawn a toogleable viewport to display a 2D view of the world.
# The character property should point towards the character to follow, and it will spawn a
# RemoteTransform3D as a child.
####################################################################################################
extends Node

@export var character : NodePath

func _ready():
	var remote = RemoteTransform3D.new()
	get_node(character).add_child(remote)
	remote.position = Vector3(10,10,10)
	remote.rotation_degrees = Vector3(-45, 45, 0)
	remote.remote_path = remote.get_path_to(%SubViewport/Camera3D)

	%SubViewport.world_3d = get_tree().root.get_world_3d()

func _on_check_button_toggled(toggled_on):
	%DebugTextureRect.visible = toggled_on
