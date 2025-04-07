extends Control

@onready var progress_bar: TextureProgressBar = $PanelContainer/TextureProgressBar

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		progress_bar.value += 1
	elif Input.is_action_pressed("move_down"):
		progress_bar.value -= 1
