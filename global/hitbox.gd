extends Area2D
class_name Hitbox

@export var damage: float = 1 : set = set_damage, get = get_damage

func set_damage(value: float):
	damage = value

func get_damage() -> float:
	return damage
