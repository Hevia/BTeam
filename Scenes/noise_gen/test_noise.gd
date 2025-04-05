extends Node2D

const TEST_TILE =  Vector2i(1,0)
const BEDROCK_TILE = Vector2i(1,1)

@export var tilemap_floor: TileMapLayer
@export var player: Player
@export var noise_tile_threshold: float = 0.5
@export var noise_Text: NoiseTexture2D

@onready var texture = NoiseTexture2D.new()
@onready var viewport_size = get_viewport_rect().size


func _ready() -> void:
	player.player_digging.connect(on_player_digging)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("TEST_LEVELGEN"):
		get_viewport().set_input_as_handled()
		make_level()
		return

func refresh_noise(x,y) -> void:
	texture.width = x
	texture.height = y
	
	texture.noise = FastNoiseLite.new()
	texture.noise.noise_type  = [1].pick_random()
	texture.noise.seed = randi()
	texture.noise.frequency = randf_range(0.05, 0.0734)
	texture.noise.offset = Vector3(randi_range(0,10), randi_range(0,10), randi_range(0,10))
	noise_tile_threshold = randf_range(-1,1)
	
func make_level():
	tilemap_floor.clear()
	var tilemap_size = tilemap_floor.local_to_map(tilemap_floor.to_local(viewport_size)) * 1.2
	refresh_noise(tilemap_size.x, tilemap_size.y) 
	for x in range(tilemap_size.x):
		for y in range(tilemap_size.y):
			var noise_val = texture.noise.get_noise_2d(x, y)
			if noise_val >= noise_tile_threshold:
				var tile_pos = Vector2(x, y)
				tilemap_floor.set_cell(tile_pos, 1, TEST_TILE)
	

func on_player_digging(mouse_pos: Vector2):
	# Its a global mouse pos we need locally on the tilemap
	var local_pos = tilemap_floor.to_local(mouse_pos)
	var tile_pos = tilemap_floor.local_to_map(local_pos)
	var tile_data = tilemap_floor.get_cell_tile_data(tile_pos)
	if tile_data:
		if tile_data.get_custom_data("Digable"):
			tilemap_floor.erase_cell(tile_pos)
