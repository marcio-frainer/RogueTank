extends Node

var score = 0 setget set_score

signal score_changed

func _ready():
	pass # Replace with function body.

func set_score(val):
	print("Does not possible add score diretly. Use function add_score.")

func add_score(val):
	score += val
	emit_signal("score_changed")
