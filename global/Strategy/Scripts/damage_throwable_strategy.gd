class_name DamageBulletStrategy
extends BaseThrowableStrategy

func apply_upgrade(throwable: Throwable):
	throwable.projectile_damage += 1
