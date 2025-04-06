extends Control

var self_opened = false

func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		toggle_pause_menu()

func toggle_pause_menu():
	self_opened = !self_opened
	if self_opened:
		self.visible = true
	else:
		self.visible = false

func _on_resume_pressed() -> void:
	toggle_pause_menu()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
