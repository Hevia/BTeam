class_name BaseThrowableStrategy
extends Resource

@export var texture : Texture2D = preload("uid://c1ecysp4ypwik")
@export var upgrade_text: String = "Blank!"

func apply_upgrade(throwable: Throwable):
	# Does nothing by default
	pass
