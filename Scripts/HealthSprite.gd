extends ColorRect

onready var init_health = rect_size
var health = 1 setget set_health

func _ready():
	pass # Replace with function body.

func _draw():
	draw_rect(Rect2(Vector2(), init_health), Color(1, 1, 1, .6), false, 1)
	
func set_health(val):
	health = val
	rect_size.x = init_health.x * health
