extends Area2D
class_name Hurtbox

signal received_damage(damage: float)

@export var health: Health

func _ready():
	connect("area_entered", _on_area_entered)


func _on_area_entered(hitbox: Hitbox) -> void:
	print("Projectile Hit")
	if hitbox != null:
		print("projectile damaged!")
		print(hitbox.get_parent() is Throwable)
		health.health -= hitbox.damage
		received_damage.emit(hitbox.damage)
	if hitbox.get_parent() is Throwable:
		print(hitbox.get_parent())
		hitbox.get_parent().queue_free()
