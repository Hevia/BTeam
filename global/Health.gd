class_name Health
extends Node

signal max_health_changed(max_health: int)
signal health_changed(health: int)
signal health_changed_diff(difference: int)
signal health_depleted

@export var max_health: int = 6 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality
@export var max_health_cap: int = 20

var immortality_timer: Timer = null
var damaged: bool = false

@onready var health: int = max_health : set = set_health, get = get_health

func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value
	
	if max_health == max_health_cap:
		pass
	elif not clamped_value == max_health:
		max_health = value
		max_health_changed.emit(max_health)
		
		if health > max_health:
			health = max_health
			health_changed.emit(health)

func get_max_health() -> int:
	return max_health

func set_immortality(value: bool):
	immortality = value

func get_immortality() -> bool:
	return immortality

func set_temporary_immortality(time: float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
	
	if immortality_timer.timeout.is_connected(set_immortality):
		immortality_timer.timeout.disconnect(set_immortality)
	
	immortality_timer.set_wait_time(time)
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start
	print(immortality_timer.time_left)

func set_health(value: int):
	if value < health and immortality:
		return
	
	var clamped_value = clampi(value, 0, max_health)
	
	if clamped_value != health:
		var difference = value - health
		health = value
		health_changed.emit(health)
		health_changed_diff.emit(difference)
		
		if health <= 0:
			health_depleted.emit()

func get_health() -> int:
	return health
