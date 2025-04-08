class_name EnemySpawner
extends Node2D

@export var spawn_location: Vector2
@export var enemy: PackedScene
@export var player_trigger: Area2D
@export var spawn_point: Marker2D
var spawned:bool = false

func _ready():
	spawn_point.position = spawn_location


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !spawned:
			print("yo worm")
			var new_enemy = enemy.instantiate()
			new_enemy.global_position = body.global_position
			
