extends Area2D

func _ready():
	pass # Replace with function body.

func _on_Oil_body_entered(body):
	add_to_group(str(body) + "-oil")

func _on_Oil_body_exited(body):
	remove_from_group(str(body) + "-oil")
