extends Node2D

const TEST_TILE =  Vector2i(1,0)
const BEDROCK_TILE = Vector2i(1,1)

@export var tilemap_floor: TileMapLayer
@export var player: Player

@onready var level_maker: LevelMaker = LevelMaker.new()

func _ready() -> void:
	player.player_digging.connect(on_player_digging)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("TEST_LEVELGEN"):
		get_viewport().set_input_as_handled()
		make_level()
		return
	if event.is_action_pressed("CAMERA_ZOOM_IN"):
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("CAMERA_ZOOM_OUT"):
		get_viewport().set_input_as_handled()
		return
		
func make_level():
	tilemap_floor.clear()
	var viewport_size = tilemap_floor.local_to_map(tilemap_floor.to_local(get_viewport_rect().size))   
	var level = level_maker.make_floor(viewport_size)
	var floor_tiles = level["floor_tiles"]
	var bedrock_tiles = level["bedrock_tiles"]
	print("Level size: " + str(floor_tiles.size()))
	for tile in floor_tiles:
		tilemap_floor.set_cell(tile, 1, TEST_TILE)
	
	for tile in bedrock_tiles:
		tilemap_floor.set_cell(tile, 1, BEDROCK_TILE)

func on_player_digging(mouse_pos: Vector2):
	# Its a global mouse pos we need locally on the tilemap
	var local_pos = tilemap_floor.to_local(mouse_pos)
	var tile_pos = tilemap_floor.local_to_map(local_pos)
	var tile_data = tilemap_floor.get_cell_tile_data(tile_pos)
	if tile_data:
		if tile_data.get_custom_data("Digable"):
			tilemap_floor.erase_cell(tile_pos)
