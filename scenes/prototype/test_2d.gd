extends Node2D

const TEST_TILE =  Vector2i(1,1)

@export var tilemap_floor: TileMapLayer
@export var camera_2d: Camera2D

@onready var level_maker: LevelMaker = LevelMaker.new()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("TEST_LEVELGEN"):
		get_viewport().set_input_as_handled()
		make_level()
		return
	if event.is_action_pressed("CAMERA_ZOOM_IN"):
		get_viewport().set_input_as_handled()
		camera_2d.zoom *= 1.1
		return
	if event.is_action_pressed("CAMERA_ZOOM_OUT"):
		get_viewport().set_input_as_handled()
		camera_2d.zoom /= 1.1
		return
		
func make_level():
	tilemap_floor.clear()
	for tile in level_maker.make_floor(200):
		tilemap_floor.set_cell(tile, 1, TEST_TILE)
	camera_2d.position = tilemap_floor.map_to_local(tilemap_floor.get_used_rect().get_center())
