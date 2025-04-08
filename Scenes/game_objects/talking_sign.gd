extends Node2D

@export var sign_text: RichTextLabel

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		sign_text.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		sign_text.visible = false
