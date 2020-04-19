extends Area2D

const VELOCITY = 200
var max_distance = 300
var direction = Vector2() setget set_direction
onready var init_position = global_position

func _ready():
	pass

func _physics_process(delta):
	translate(direction * VELOCITY * delta)
	if global_position.distance_to(init_position) > max_distance:
		queue_free()
		
func set_direction(val):
	direction = val
	rotation = val.angle()
