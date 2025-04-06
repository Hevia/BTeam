class_name BaseUpgradeStrategy
extends Resource

@export var texture : Texture2D = preload("uid://c1ecysp4ypwik")
@export var upgrade_text: String = "Blank!"

func apply_throwable_upgrade(throwable: Throwable):
	# Does nothing by default
	pass

func apply_player_upgrade(player: Player):
	# Does nothing by default
	pass
