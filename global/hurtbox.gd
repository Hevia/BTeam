class_name Hurtbox
extends Area2D

signal received_damage(damage: float)

@export var health: Health

func _ready():
	connect("area_entered", _on_area_entered)


func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox != null:
		health.health -= hitbox.damage
		received_damage.emit(hitbox.damage)
	if hitbox.get_parent() is Throwable:
		hitbox.get_parent().queue_free()
