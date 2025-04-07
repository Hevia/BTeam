extends GridContainer

var heart_full = preload("res://UI/assets/heartfull.png")
var heart_empty = preload("res://UI/assets/heartempty.png")
var heart_half = preload("res://UI/assets/hearthalf.png")

func update_max(value):
	for i in get_child_count():
		if value/2 == int(value/2):
			get_child(i).visible = value/2 >= i + 1
		else:
			get_child(i).visible = (value + 1)/2 >= i + 1

func update_partial(value):
	for i in get_child_count(value):
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty
