extends RigidBody2D

export var boncing = .3
var power = 200

func _ready():
	$Poly.scale = get_parent().scale
	$Poly2.scale = get_parent().scale
	bounce = boncing
	gravity_scale = 0
	linear_damp = rand_range(.6, 1)
	angular_velocity = randf() * 80
	var dir = randf() * (PI * 2)
	apply_impulse(Vector2(), Vector2(cos(dir), sin(dir)) * power)
