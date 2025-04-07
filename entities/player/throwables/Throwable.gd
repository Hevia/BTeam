class_name Throwable
extends RigidBody2D

@export var collider: CollisionShape2D
@export var projectile_damage: int = 1
@export var throw_force: float = 650
@export var projectile_lifetime: float = 6
@export var hitbox: Hitbox

func _ready():
	add_to_group("throwables")
	if hitbox is Hitbox:
		hitbox.damage = projectile_damage

func _physics_process(delta: float):
	projectile_lifetime -= delta
	if projectile_lifetime <= 0:
		queue_free()

func throw(initial_force: float, direction: Vector2):
	var unit_direction := direction.normalized()
	var impulse := unit_direction * initial_force
	apply_central_impulse(impulse)
