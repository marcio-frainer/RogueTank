extends Area2D

signal hitted(damage, health, node)
signal destroid()

export var _health = 50

func hit(damage, node):
	_health -= damage
	emit_signal("hitted", damage, _health, node)
	if _health <= 0:
		emit_signal("destroid")	
