extends Node2D

const ROOM_SIZE = Vector2i(20, 16)

# Called when the node enters the scene tree for the first time.
func _ready():
	var per_room_patterns =  {}

	# Procedurally generate a room pattern.
	var used_rect_size = $TileMap.get_used_rect().size
	for room_x in range(used_rect_size.x / ROOM_SIZE.x):
		for room_y in range(used_rect_size.y / ROOM_SIZE.y):
			per_room_patterns[Vector2i(room_x, room_y)] = get_room_patterns(Vector2i(room_x, room_y))

	# Duplicate and clear the source TileMap.
	$TileMap.clear()
	
	for x in range(10):
		for y in range(10):
			generate_room(Vector2i(x,y), per_room_patterns)

func get_room_patterns(room_coords: Vector2i):
	var coords_list : PackedVector2Array = []
	for x in range(room_coords.x * ROOM_SIZE.x, (room_coords.x + 1) * ROOM_SIZE.x):
		for y in range(room_coords.y * ROOM_SIZE.y, (room_coords.y + 1) * ROOM_SIZE.y):
			coords_list.push_back(Vector2i(x,y))

	var output = []
	for layer in range($TileMap.get_layers_count()):
		output.push_back($TileMap.get_pattern(layer, coords_list))
	return output

func generate_room(room_coords: Vector2i, per_room_patterns: Dictionary):
	# Pick a random room
	var random_key = per_room_patterns.keys().pick_random()

	for layer in range($TileMap.get_layers_count()):
		$TileMap.set_pattern(layer, room_coords * ROOM_SIZE, per_room_patterns[random_key][layer])
