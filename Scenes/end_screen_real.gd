extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.
