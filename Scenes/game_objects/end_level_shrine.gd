extends Node2D

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var hurt_area_2d: Area2D = $HurtArea2D

@export var health: int = 4

func _ready() -> void:
	hurt_area_2d.area_entered.connect(on_area_entered)
	
func on_area_entered(other_area):
	pass
	
func on_shrine_hurt() -> void:
	sprite_2d.material.set_shader_parameter("shake_intensity", 1.0)
	await get_tree().create_timer(1.0).timeout
	sprite_2d.material.set_shader_parameter("shake_intensity", 0.0)
