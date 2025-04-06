class_name PlayerSpeedUpgradeStrategy
extends BaseUpgradeStrategy

func apply_player_upgrade(player: Player):
	player.max_speed += 50
	player.acceleration_speed += 12.5
