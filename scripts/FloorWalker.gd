class_name FloorWalker extends RefCounted

const CARDINAL_DIR = [Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN]

var position: Vector2i
var direction: Vector2i

func _init(new_position: Vector2i = Vector2i.ZERO, new_direction: Vector2i = Vector2i.RIGHT) -> void:
	position = new_position
	direction = CARDINAL_DIR.pick_random()

func step() -> Vector2i:
	position += direction
	
	# 30% chance to step twice for testing
	if randf_range(0, 1) < 0.3:
		position += direction
	
	return position

func rotate(num_lefts: int) -> void:
	# rotate the direction to the left 90*num_lefts
	num_lefts = (num_lefts + CARDINAL_DIR.find(direction)) % 4
	direction = CARDINAL_DIR[num_lefts] # wraps cardinal directions onto itself
	
	# 20% chance to rotate again
	if randf_range(0, 1) < 0.2:
		num_lefts = (randi_range(1, 5) + CARDINAL_DIR.find(direction)) % 4
		direction = CARDINAL_DIR[num_lefts] # wraps cardinal directions onto itself
