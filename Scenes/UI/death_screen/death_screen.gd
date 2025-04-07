extends Control

@export var pause_menu: Control
var is_dead: bool = false

func you_died():
	pause_menu.can_pause = false
	get_tree().paused = true
	self.visible = true

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
