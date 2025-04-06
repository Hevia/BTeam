@tool
extends Area2D

@export var upgrade_label : Label
@export var sprite : Sprite2D
@export var player_strategy : BaseUpgradeStrategy:
	set(val):
		player_strategy = val
		needs_update = true

@export var needs_update := false

signal upgrade_get

func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = player_strategy.texture
	upgrade_label.text = player_strategy.upgrade_text

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if needs_update:
			sprite.texture = player_strategy.texture
			upgrade_label.text = player_strategy.upgrade_text
			needs_update = false

func on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.player_upgrades.append(player_strategy)
		upgrade_get.emit()
		
		queue_free()
