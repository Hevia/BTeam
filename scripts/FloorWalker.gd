class_name FloorWalker extends RefCounted

const CARDINAL_DIR = [Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN]

var position: Vector2i
var direction: Vector2i
var viewport_limits: Vector2



func _init(viewport_size: Vector2i, new_position: Vector2i = Vector2i.ZERO) -> void:
	viewport_limits = viewport_size
	position = new_position
	direction = CARDINAL_DIR.pick_random()
	
func check_if_in_limits(new_pos: Vector2, curr_direction: Vector2i):
	if new_pos.x < 0:
		return Vector2i.RIGHT
	
	if new_pos.x > viewport_limits.x:
		return Vector2i.LEFT
		
	if new_pos.y < 0:
		return Vector2i.DOWN
	
	if new_pos.y > viewport_limits.y:
		return Vector2i.UP
		
	return curr_direction

func get_step_multiplier() -> int:
	var prob = randf_range(-3, 3) # normal distribution
	if prob <= -1:
		return 2
	
	if prob >= 1:
		return 3
	
	return 1

func step() -> Vector2i:
	var step_multiplier = get_step_multiplier()
	var proposed_position = position + (direction * step_multiplier)
	direction = check_if_in_limits(proposed_position, direction)
	position += (direction * step_multiplier)
	
	return position

func rotate(num_lefts: int) -> void:
	# rotate the direction to the left 90*num_lefts
	num_lefts = (num_lefts + CARDINAL_DIR.find(direction)) % 4
	direction = CARDINAL_DIR[num_lefts] # wraps cardinal directions onto itself
	
	# 20% chance to rotate again
	if randf_range(0, 1) < 0.2:
		num_lefts = (randi_range(1, 5) + CARDINAL_DIR.find(direction)) % 4
		direction = CARDINAL_DIR[num_lefts] # wraps cardinal directions onto itself
