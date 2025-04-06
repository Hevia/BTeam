class_name DialogTrigger extends Node2D

@export var text: String

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)
	area_2d.area_exited.connect(on_area_exited)
	rich_text_label.text = text

func show_message():
	rich_text_label.visible = true
	
func hide_message():
	rich_text_label.visible = false
	
func on_area_entered(other_area: Area2D):
	if other_area and other_area.owner is Player:
		show_message()


func on_area_exited(other_area: Area2D):
	if other_area and other_area.owner is Player:
		hide_message()
