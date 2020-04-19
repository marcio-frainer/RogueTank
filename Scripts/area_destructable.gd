extends Area2D

signal hitted(damage, node)

func hit(damage, node):
	emit_signal("hitted", damage, node)
