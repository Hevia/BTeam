extends CharacterBody2D


@export var speed: float = 300
@export var jumpVelocity: float = 400


func _physics_process(delta: float):
	# Add the gravity.
	velocity += get_gravity() * delta
	
	jump()
	movePlayer()
	
	move_and_slide()

func jump():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jumpVelocity
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = move_toward(velocity.y, 0, get_gravity().y/2)

func movePlayer():
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
