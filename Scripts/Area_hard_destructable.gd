extends Area2D

signal hitted(damage, initial_health, health, node)
signal is_destroing()

const initial_health = 100
var health = initial_health

func hit(damage, node):
	health -= damage
	if health <= 0:
		emit_signal("is_destroing")
	else:	
		emit_signal("hitted", damage, initial_health, health, node)
