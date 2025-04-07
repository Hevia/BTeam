class_name Levels extends Node2D

@export var tilemap_floor: TileMapLayer
@export var player: Player

@onready var rock_particles_vfx = preload("res://Scenes/vfx/rock_breaking_particles.tscn")

func _ready() -> void:
	player.player_digging.connect(on_player_digging)


func on_player_digging(mouse_pos: Vector2):
	# Its a global mouse pos we need locally on the tilemap
	var local_pos = tilemap_floor.to_local(mouse_pos)
	var tile_pos = tilemap_floor.local_to_map(local_pos)
	var tile_data = tilemap_floor.get_cell_tile_data(tile_pos)
	if tile_data:
		if tile_data.get_custom_data("Digable"):
			tilemap_floor.erase_cell(tile_pos)
			var rock_particles_instance = rock_particles_vfx.instantiate() as Particle
			get_tree().root.add_child(rock_particles_instance)
			rock_particles_instance.global_position = mouse_pos
			rock_particles_instance.trigger_particle()
