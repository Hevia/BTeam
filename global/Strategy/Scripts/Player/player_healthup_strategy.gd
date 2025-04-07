class_name PlayerHealthupStrategy
extends BaseUpgradeStrategy

func apply_player_upgrade(player: Player):
	var health_handler: Health = player.get_child(1)
	health_handler.max_health += 2
	health_handler.health += 2
	print("Max Health: ", health_handler.max_health)
	print("Current Health: ", health_handler.health)
