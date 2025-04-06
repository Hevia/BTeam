class_name DamageThrowableStrategy
extends BaseUpgradeStrategy

func apply_throwable_upgrade(throwable: Throwable):
	throwable.projectile_damage += 1
