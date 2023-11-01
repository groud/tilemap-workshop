extends TileMap

const TILEMAP_LAYER = 0

var tile_height = {}

func _ready():
	get_viewport().disable_3d = true

	var used_rect : Rect2i = get_used_rect()
	for x in range(used_rect.size.x):
		var shape_origin = Vector3(used_rect.position.x + x, 0, used_rect.end.y)
		var holes=[]
			
		for y in range(used_rect.size.y):
			var coords = Vector2i(used_rect.position.x + x, used_rect.end.y - 1 - y)

			# Store the tile height.
			if tile_height.has(coords):
				tile_height = max(tile_height[coords], shape_origin.y)
			else:
				tile_height[coords] = shape_origin.y

			# Retrieve the IDs of the cell.
			var source_id = get_cell_source_id(TILEMAP_LAYER, coords)
			var atlas_coords = get_cell_atlas_coords(TILEMAP_LAYER, coords)
			var alternative_tile = get_cell_alternative_tile(TILEMAP_LAYER, coords)

			# A way to know where is the first hole.
			var get_base_shape_height = func(origin):
				return origin if holes.is_empty() else origin - holes[holes.size()-1] - 1

			# Check if we have a valid atlas tile.
			if tile_set.has_source(source_id) and tile_set.get_source(source_id).get_tile_data(atlas_coords, alternative_tile):
				var tile_data = tile_set.get_source(source_id).get_tile_data(atlas_coords, alternative_tile)

				# Add slabs for each holes.
				for i in range(holes.size()):
					if i == 0 and holes[0] > 0:
						
						spawn_shape(Vector3(shape_origin.x, holes[0], shape_origin.z), holes[0], TileStaticBody.ShapeType.SLAB)
					elif i > 0 and holes[i] - holes[i-1] >= 0.9:
						spawn_shape(Vector3(shape_origin.x, holes[i], shape_origin.z), holes[i] - holes[i-1] - 1, TileStaticBody.ShapeType.SLAB)

				# Add walkable shape.
				var wall_type : int = tile_data.get_custom_data("wall_type")
				if wall_type == 1:
					 # Wall.
					spawn_shape(shape_origin, get_base_shape_height.call(shape_origin.y), TileStaticBody.ShapeType.WALL)
					shape_origin.y += 1
				elif wall_type == 2:
					 # Hole.
					holes.append(shape_origin.y)
					shape_origin.y += 1
				elif wall_type == 3:
					 # Slope.
					spawn_shape(shape_origin, get_base_shape_height.call(shape_origin.y), TileStaticBody.ShapeType.SLOPE)
					shape_origin.y += 0.5
					shape_origin.z -= 0.5
				else:
					# Slab.
					spawn_shape(shape_origin, get_base_shape_height.call(shape_origin.y), TileStaticBody.ShapeType.SLAB)
					shape_origin.z -= 1
			else:
				shape_origin.z -= 1
				shape_origin.y = 0
				holes = []

	notify_runtime_tile_data_update()

func spawn_shape(pos: Vector3, shape_base_height: float, shape_type: TileStaticBody.ShapeType):
	# Spawn the shape (cube)
	var shape_stack = TileStaticBody.new()
	shape_stack.shape_type = shape_type
	shape_stack.shape_base_height = shape_base_height
	$"../../WorldIn3D/GeneratedCollisionShapes".add_child(shape_stack)
	shape_stack.global_position = pos

func _use_tile_data_runtime_update(layer, coords):
	return tile_height.has(coords)

func _tile_data_runtime_update(layer, coords, tile_data : TileData):
	tile_data.y_sort_origin = tile_height[coords] * 16 + tile_data.y_sort_origin
