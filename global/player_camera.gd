extends Node2D

@onready var player: Node = get_node_or_null("../Player")

func _ready():
	var current_parent = get_parent()
	if current_parent:
		current_parent.remove_child.call_deferred(self)
	if player:
		player.add_child(self)
		transform.origin = Vector2(0,-5)
