extends RigidBody2D
class_name Throwable

@export var collider: CollisionShape2D
@export var throw_force: float = 640
@export var projectile_lifetime: float = 6

func _ready():
	add_to_group("throwables")

func _physics_process(delta: float):
	projectile_lifetime -= delta
	if projectile_lifetime <= 0:
		queue_free()

func throw(initial_force: float, direction: Vector2):
	var unit_direction := direction.normalized()
	var impulse := unit_direction * initial_force
	apply_central_impulse(impulse)

func _on_hitbox_area_entered(area: Area2D) -> void:
	queue_free()
