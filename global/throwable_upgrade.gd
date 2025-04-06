@tool
extends Area2D

@export var upgrade_label : Label
@export var sprite : Sprite2D
@export var throwable_strategy : BaseUpgradeStrategy:
	set(val):
		throwable_strategy = val
		needs_update = true

@export var needs_update := false

func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = throwable_strategy.texture
	upgrade_label.text = throwable_strategy.upgrade_text

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if needs_update:
			sprite.texture = throwable_strategy.texture
			upgrade_label.text = throwable_strategy.upgrade_text
			needs_update = false

func on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.throwable_upgrades.append(throwable_strategy)
		
		queue_free()
