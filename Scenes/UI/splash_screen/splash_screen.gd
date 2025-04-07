extends Control

func _ready():
	$AnimationPlayer.play("splash_screen")

func _input(event: InputEvent):
	if event is InputEventKey:
		queue_free()

func end_splash():
	queue_free()
