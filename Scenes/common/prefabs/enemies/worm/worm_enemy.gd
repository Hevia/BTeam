extends CharacterBody2D

@export var health: Health

@export var move_speed: float = 250
@export var acceleration_speed: float = 25
@export var behind_slow_factor: float = 5
@export var far_speed_factor: float = 5
@export var close_slow_factor: float = 2
@export var rotation_speed: float = 10
@export var segment_follow_speed: float

@onready var middle_body: CharacterBody2D = $"../MiddleBody"
@onready var tail: CharacterBody2D = $"../Tail"
@onready var head_target: Marker2D = $HeadTarget
@onready var body_target: Marker2D = $"../MiddleBody/BodyTarget"

@onready var gravity = get_gravity()/3

var player: Player
var playerPOS: Vector2
var playerDistance: float
var is_in_terrain: bool = false
var is_player_close: bool = false
var active_accel_speed: float
var behind_accel_speed: float
var far_accel_speed: float
var active_rotation_speed: float
var behind_rotation_speed: float

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	segment_follow_speed = move_speed
	active_accel_speed = acceleration_speed
	behind_accel_speed = acceleration_speed/behind_slow_factor
	far_accel_speed = acceleration_speed * far_speed_factor
	active_rotation_speed = rotation_speed
	behind_rotation_speed = rotation_speed/2

func _process(delta: float):
	#print("Is in terrain?: ", is_in_terrain)
	if !is_in_terrain:
		gravity *=1.5
	else:
		gravity = get_gravity()/2
	
	#if is_player_close:
		#active_accel_speed = acceleration_speed/close_slow_factor
	#else:
		#active_accel_speed = acceleration_speed
	
	if player:
		velocity += gravity * delta
		
		playerPOS = player.global_position
		playerDistance = (player.global_position - global_position).length()
		#print(playerDistance)
		var direction = (playerPOS - global_position).normalized()
		var forward_direction = Vector2(1, 0).rotated(rotation)
		
		var dot_product = forward_direction.dot(direction)
		
		if playerDistance >= 300:
			#print("player far!")
			active_accel_speed = far_accel_speed
			active_rotation_speed = rotation_speed
		elif dot_product > 0:
			#print("Player in front")
			active_accel_speed = acceleration_speed
			active_rotation_speed = rotation_speed
		elif dot_product < 0:
			#print("Player behind")
			active_accel_speed = behind_accel_speed
			active_rotation_speed = behind_rotation_speed
		else:
			print("Shit sideways idk")
		
		
		
		velocity += direction * active_accel_speed
		
		velocity.x = clamp(velocity.x, -move_speed, move_speed)
		velocity.y = clamp(velocity.y, -move_speed, move_speed)
		
		if velocity.length_squared() > 0.01:
			var target_rotation = velocity.angle()
			var rotation_difference = target_rotation - rotation
			
			rotation_difference = wrapf(rotation_difference, -PI, PI)
			rotation += rotation_difference * rotation_speed * delta
		
		move_and_slide()
	if middle_body:
		var headPOS = head_target.global_position
		
		var direction = (headPOS - middle_body.global_position).normalized()
		
		middle_body.velocity += direction * velocity.length() - Vector2(0.5, 0.5)
		
		middle_body.velocity.x = clamp(middle_body.velocity.x, -segment_follow_speed, segment_follow_speed)
		middle_body.velocity.y = clamp(middle_body.velocity.y, -segment_follow_speed, segment_follow_speed)
		
		if middle_body.velocity.length_squared() > 0.01:
			var target_rotation = middle_body.velocity.angle()
			var rotation_difference = target_rotation - middle_body.rotation
			
			rotation_difference = wrapf(rotation_difference, -PI, PI)
			middle_body.rotation += rotation_difference * rotation_speed * delta
		middle_body.move_and_slide()
	
	if tail:
		var bodyPOS = body_target.global_position
		
		var direction = (bodyPOS - tail.global_position).normalized()
		
		tail.velocity += direction * middle_body.velocity.length() - Vector2(0.5, 0.5)
		
		tail.velocity.x = clamp(tail.velocity.x, -segment_follow_speed, segment_follow_speed)
		tail.velocity.y = clamp(tail.velocity.y, -segment_follow_speed, segment_follow_speed)
		
		if tail.velocity.length_squared() > 0.01:
			var target_rotation = tail.velocity.angle()
			var rotation_difference = target_rotation - tail.rotation
			
			rotation_difference = wrapf(rotation_difference, -PI, PI)
			tail.rotation += rotation_difference * rotation_speed * delta
		tail.move_and_slide()

func _on_terrain_detector_body_entered(body: Node2D) -> void:
	#print("entertriggered")
	is_in_terrain = true

func _on_terrain_detector_body_exited(body: Node2D) -> void:
	#print("exit triggered")
	is_in_terrain = false


func _on_player_close_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_close = true


func _on_player_close_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_close = false

func _on_health_health_depleted() -> void:
	get_parent().queue_free()
