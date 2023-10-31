####################################################################################################
# --- tile_static_body.gd ---  
# 
# This scene generates a collision shape according to a provided shape_type. # It provides simple
# shapes that are useful when used with a TileMap. Availabes shapes are:
# - SLAB:  a (1, 0.2, 1) slab, should be used for floor tiles.
# - WALL:  a (1, 0.2, 1) vertical wall, should be used for wall tiles.
# - SLOPE: a (1, 0.5, 0.5) slope, should be used for stair tiles.
# 
# The shape_base_height paramtere extends the shape by the given amount below the origin. This is
# useful for making sure nothing goes under a given floor/slope.
####################################################################################################

extends StaticBody3D
class_name TileStaticBody

enum ShapeType { SLAB, WALL, SLOPE}

static var shape3D_cache = {}

@export var shape_type: ShapeType:
	set(value):
		shape_type = value
		update_collision_shape()
@export var shape_base_height: float:
	set(value):
		shape_base_height = max(value, 0)
		update_collision_shape()

func update_collision_shape():
	# Free all children.
	for i in range(get_child_count()):
		get_child(i).queue_free()

	# Recreate the stack.
	var collision_shape = get_collision_shape()
	if collision_shape:
		add_child(collision_shape)

func get_collision_shape():
	# Instantiate the shape node.
	var collision_shape = CollisionShape3D.new()
	var key = Vector2(shape_type, shape_base_height)
	if (!shape3D_cache.has(key)):
		# Fills in the cache.
		if shape_type == ShapeType.SLAB:
			var cube_shape = BoxShape3D.new()
			cube_shape.size = Vector3(1, max(shape_base_height, 0.2), 1)
			shape3D_cache[key] = cube_shape
		if shape_type == ShapeType.WALL:
			var cube_shape = BoxShape3D.new()
			cube_shape.size = Vector3(1, 1, 0.2)
			shape3D_cache[key] = cube_shape
		elif shape_type == ShapeType.SLOPE:
			var points = []

			points.append(Vector3(0, -shape_base_height, 0))
			points.append(Vector3(1, -shape_base_height, 0))
			points.append(Vector3(1, -shape_base_height, -0.5))
			points.append(Vector3(0, -shape_base_height, -0.5))
			
			points.append(Vector3(0, 0, 0))
			points.append(Vector3(1, 0, 0))
			#points.append(Vector3(1, 0, -0.5))
			#points.append(Vector3(0, 0, -0.5))

			points.append(Vector3(0, 0.5, -0.5))
			points.append(Vector3(1, 0.5, -0.5))

			var convex_polygon_shape = ConvexPolygonShape3D.new()
			convex_polygon_shape.points = points
			shape3D_cache[key] = convex_polygon_shape

	## Offsets.
	if shape_type == ShapeType.SLAB:
		collision_shape.position = Vector3(0.5, -max(shape_base_height, 0.2) / 2.0, -0.5)
	elif shape_type == ShapeType.WALL:
		collision_shape.position = Vector3(0.5, 0.5, -0.1)

	collision_shape.shape = shape3D_cache[key]
	return collision_shape
