class_name DamageThrowableStrategy
extends BaseUpgradeStrategy

func apply_throwable_upgrade(throwable: Throwable):
	throwable.projectile_damage += 1

func apply_player_upgrade(player: Player):
	player.primary_hitbox.damage += 1
