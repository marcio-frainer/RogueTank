extends Area2D

var velocity_rotation = PI
var velocity = 90
var target
var following = false

onready var _sprite = $Sprite
onready var _shape = $Shape
onready var _smoke = $Smoke
onready var _fire = $Fire

func _ready():
	yield(get_tree().create_timer(1.5), "timeout")
	following = true
	
func _process(delta):
	if !target:
		return
	if following:
		var angle = get_angle_to(target.global_position)
		if abs(angle) > .01:
			rotation += velocity_rotation * delta * sign(angle)
	translate(Vector2(cos(rotation), sin(rotation)).normalized() * velocity * delta)

func _on_Home_missil_body_entered(body):
	_sprite.hide()
	_shape.queue_free()
	set_process(false)
	_smoke.emitting = false
	_fire.emitting = false
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
