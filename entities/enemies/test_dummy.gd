extends CharacterBody2D

@export var health: Health
@export var health_label: Label

func _ready():
	health_label.text = (str(health.health))

func _on_health_health_depleted() -> void:
	queue_free()

func _on_health_health_changed(difference: int) -> void:
	health_label.text = (str(health.health))
