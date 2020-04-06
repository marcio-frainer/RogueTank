extends Area2D

signal hitted(damage, initial_health, health, node)
signal is_destroing()

const INITIAL_HEALTH = 60
var health = INITIAL_HEALTH

func hit(damage, node):
	health -= damage
	if health <= 0:
		emit_signal("is_destroing")
	else:	
		emit_signal("hitted", damage, INITIAL_HEALTH, health, node)
