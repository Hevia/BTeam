class_name SpeedThrowableStrategy
extends BaseUpgradeStrategy

func apply_throwable_upgrade(throwable: Throwable):
	throwable.throw_force += 100
