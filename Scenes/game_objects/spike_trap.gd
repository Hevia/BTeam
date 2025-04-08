extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
var is_anim: bool = false

func _ready():
	anim.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if is_anim:
			return
		else:
			is_anim = true
			anim.play("stab")
			anim.queue("idle")

func anim_finished():
	is_anim = false
