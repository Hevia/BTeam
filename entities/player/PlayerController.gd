extends CharacterBody2D

@export var player_health: Health
@export var speed: float = 300
@export var jump_velocity: float = 400
@export var wall_slide_slow: float = 4
@export var wall_jump_force: float = 500
@export var wall_jump_lerp_weight: float = 0.5
@export var wall_jump_cooldown_duration: float = 0.5
@export var air_friction: float = 200

var can_wall_jump: bool = false
var wall_jump_input_cooldown: float = 0.0
var last_wall_normal: Vector2 = Vector2.ZERO
var is_wall_sliding: bool = false
var gravity

func _ready():
	gravity = get_gravity()
	jump_velocity = -jump_velocity

func _physics_process(delta: float):
	if wall_jump_input_cooldown > 0.0:
		wall_jump_input_cooldown -= delta
		
		var target_x_velocity = last_wall_normal.x * wall_jump_force
		velocity.x = lerp(velocity.x, target_x_velocity, wall_jump_lerp_weight)
	
	var on_wall = is_on_wall_only() and !is_on_floor()
	
	# Wall sliding
	if is_on_wall_only() and velocity.y > 0:
		gravity = get_gravity()/wall_slide_slow
		is_wall_sliding = true
	else:
		gravity = get_gravity()
		is_wall_sliding = false
	
	# Wall jumping
	if on_wall:
		can_wall_jump = true
	else:
		can_wall_jump = false
	
	# Add the gravity.
	velocity += gravity * delta
	
	
	
	jump()
	movePlayer(delta)
	
	move_and_slide()

func jump():
	# Handle Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif can_wall_jump:
			last_wall_normal = get_wall_normal()
			velocity.y = jump_velocity
			wall_jump_input_cooldown = wall_jump_cooldown_duration
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = move_toward(velocity.y, 0, abs(gravity.y/4))

func movePlayer(delta: float):
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if wall_jump_input_cooldown <= 0.0:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	elif last_wall_normal.x == direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction)
