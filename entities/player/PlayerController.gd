class_name Player extends CharacterBody2D

@onready var camera_2d: Camera2D = $Camera2D

@export var player_health: Health
@export var visuals: Node2D
@export var animation_player: AnimationPlayer
@export var sprite_main: Sprite2D
@export var sprite_sub: Sprite2D
@export var projectile_spawn: Marker2D
@export var max_speed: float = 200
@export var acceleration_speed: float = 50
@export var deceleration_speed: float = 50
@export var jump_velocity: float = 350
@export var wall_slide_slow: float = 4
@export var wall_jump_force: float = 650
@export var wall_jump_max_speed: float = 100 # nevermind dont go past 100 lol
@export var wall_jump_lerp_speed: float = 150
@export var DIGGING_RANGE: int  = 150
@export var throw_force: float = 650

var can_wall_jump: bool = false
var last_wall_normal: Vector2 = Vector2.ZERO
var is_wall_sliding: bool = false
var gravity
var throwable
var projectile1
var projectile2
var target_move_speed: float = 0.0
var wall_jump_kick_speed: float = 0.0
var is_wall_jumping: bool = false
var player = self
var is_swinging: bool = false

signal player_digging(mouse_pos: Vector2)

enum AnimState {IDLE, WALKING, JUMP_RISE, JUMP_FALL, SWING, WALL_SLIDE, WALK_SWING, JUMP_RISE_SWING, JUMP_FALL_SWING}
var _animstate: AnimState = AnimState.IDLE
var current_frame: float = 0
var anim_bool: bool = false

# Upgrade arrays! :D
var throwable_upgrades : Array[BaseUpgradeStrategy] = []
var player_upgrades : Array[BaseUpgradeStrategy] = []

func _ready():
	gravity = get_gravity()
	jump_velocity = -jump_velocity
	# Set projectile variables to load projectile prefabs
	projectile1 = load("uid://blltbftmyr58q") # Replace UID with whatever projectile is active
	projectile2 = load("uid://b8elap8dki3xt")
	# Default active throwable to first projectile
	throwable = projectile1
	
func _process(delta: float):
	# Dig Attack
	if Input.is_action_just_pressed("attack"):
		is_swinging = true
	
	# For testing level gen and making sure it works
	if Input.is_action_just_pressed("CAMERA_ZOOM_OUT"):
		camera_2d.zoom /= 1.1
		
	# Placeholder throwable switching
	if Input.is_action_just_pressed("weapon1"):
		throwable = projectile1
	if Input.is_action_just_pressed("weapon2"):
		throwable = projectile2
	
	# Throw attack
	if Input.is_action_just_pressed("attack2"):
		# Spawn it and place it
		var projectile = throwable.instantiate() as Throwable
		projectile.position = projectile_spawn.global_position
		var direction = (get_global_mouse_position() - self.position).normalized()
		
		# Apply upgrades!
		for strategy in throwable_upgrades:
			strategy.apply_throwable_upgrade(projectile)
		
		print(projectile.throw_force)
		
		# Throw it!
		projectile.throw(projectile.throw_force, direction)
		get_parent().add_child(projectile)
	
	# Animation stuff
	animation_machine()

func _physics_process(delta: float):
	# Add the gravity.
	velocity += gravity * delta
	
	handle_jump()
	handle_movement(delta)
	handle_wall_jump(delta)
	
	move_and_slide()

func handle_jump():
	# Handle Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif can_wall_jump:
			is_wall_jumping = true
			last_wall_normal = get_wall_normal()
			velocity.y = jump_velocity
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = move_toward(velocity.y, 0, abs(gravity.y/4))

func handle_wall_jump(delta: float):
	if abs(wall_jump_kick_speed) < wall_jump_force and is_wall_jumping:
		var target_x_velocity = last_wall_normal.x * wall_jump_force
		wall_jump_kick_speed = move_toward(wall_jump_kick_speed, target_x_velocity, wall_jump_lerp_speed)
	else:
		is_wall_jumping = false
		wall_jump_kick_speed = move_toward(wall_jump_kick_speed, 0.0, wall_jump_lerp_speed)
	
	wall_jump_kick_speed = clamp(wall_jump_kick_speed, -wall_jump_max_speed, wall_jump_max_speed)
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

func handle_movement(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		target_move_speed += direction * acceleration_speed
		target_move_speed = clamp(target_move_speed, -max_speed, max_speed)
	else:
		target_move_speed = move_toward(target_move_speed, 0, deceleration_speed)
	
	print("is_wall_jumping " + str(is_wall_jumping))
	print("wall_jump_kick_speed: " + str(wall_jump_kick_speed))
	
	# Apply Movement
	velocity.x = target_move_speed + wall_jump_kick_speed
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if is_on_floor():
		is_wall_jumping = false
		wall_jump_kick_speed = 0.0
	
	# Sprite flipping based on direction
	if direction > 0:
		visuals.scale.x = 1 # Facing right
	elif direction < 0:
		visuals.scale.x = -1 # Facing left

func animation_machine():
	if is_swinging:
		if velocity.x == 0:
			if _animstate == AnimState.WALK_SWING:
				anim_bool = true
				current_frame = sprite_main.frame
				print(current_frame)
			set_state(AnimState.SWING)
		else:
			if _animstate == AnimState.SWING:
				anim_bool = true
				current_frame = sprite_main.frame
				print(current_frame)
			set_state(AnimState.WALK_SWING)
	else:
		if is_on_floor():
			if velocity.x == 0:
				set_state(AnimState.IDLE)
			else:
				set_state(AnimState.WALKING)
		elif is_wall_sliding:
			set_state(AnimState.WALL_SLIDE)
		else:
			if velocity.y > 0:
				set_state(AnimState.JUMP_FALL)
			else:
				set_state(AnimState.JUMP_RISE)

func set_state(new_state: AnimState) -> void:
	if new_state == _animstate:
		return
	
	_animstate = new_state
	
	match _animstate:
		AnimState.IDLE:
			animation_player.play("idle")
		AnimState.WALKING:
			animation_player.play("walk_full")
		AnimState.JUMP_RISE:
			animation_player.play("jump_rise")
		AnimState.JUMP_FALL:
			animation_player.play("jump_peak")
			animation_player.queue("jump_fall")
		AnimState.SWING:
			if anim_bool:
				anim_bool = false
				print("googoo")
				animation_player.play("swing_full")
				animation_player.seek(current_frame/10)
			else:
				animation_player.play("swing_full")
		AnimState.WALL_SLIDE:
			animation_player.play("wall_hold")
		AnimState.WALK_SWING:
			if anim_bool:
				anim_bool = false
				print("gaga")
				animation_player.play("walk_swing")
				animation_player.seek(current_frame/10)
			else:
				animation_player.play("walk_swing")

func animation_ended():
	is_swinging = false
	current_frame = 0

func emit_player_digging():
	# TODO: Digging radius check
	player_digging.emit(get_global_mouse_position())

func _on_player_upgrade_upgrade_get() -> void:
	for strategy in player_upgrades:
			strategy.apply_player_upgrade(player)
