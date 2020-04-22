tool
extends StaticBody2D

const BULLET = preload("res://Scenes/Turret_01_bullet.tscn")
const POINTS = 250

var bodies = []
var first_draw = true
var is_destroying = false

export(float, 0, 360) var start_rotation = 0.0 setget set_start_rotation
export(float, 100, 1000) var sensor_radius = 100.0 setget set_sensor_radius
export var health = 100
export(int, "Heavy Cannon", "Home Cannon") var _type = 0 setget set_type

onready var init_health = health
onready var _cannon = $Heavy_cannon
onready var _sensor_shape = $Sensor/Shape

signal player_entered(n)
signal player_exited(n)
signal change_shape(radius)

func _process(delta):
	if Engine.editor_hint:
		return
	rotationTurret(delta)
	analiseColliderBody()

func _on_Sensor_body_entered(body):
	bodies.append(body)
	emit_signal("player_entered", bodies.size())
	update()

func _on_Sensor_body_exited(body):
	var index = bodies.find(body)
	if index != -1:
		bodies.remove(index)
	if !bodies.size():
		emit_signal("player_exited", bodies.size())
	update()

func _draw():
	if is_destroying:
		return

	if Engine.editor_hint:
		define_cannon_visibility()

	select_cannon()

	if first_draw:
		_cannon.rotation = deg2rad(start_rotation)
		change_shape()
		if !Engine.editor_hint:
			first_draw = false
			remove_cannon()

	if bodies.size():
		draw_circle(Vector2(), _sensor_shape.shape.radius, Color(1, 0, 0, 0.1))
	draw_arc(Vector2(), _sensor_shape.shape.radius, 0, 360, 1180, Color(1, 0, 0, 0.005), 1)
	
func define_cannon_visibility():
	$Heavy_cannon.visible = _type == 0
	$Home_cannon.visible = _type == 1
	
func change_shape():
	var new_shape = CircleShape2D.new()
	new_shape.radius = sensor_radius
	if new_shape:
		_sensor_shape.shape = new_shape
	if Engine.editor_hint:
		update()

func remove_cannon():
	define_cannon_visibility()

	if _type == 0:
		$Home_cannon.queue_free()
	elif _type == 1:
		$Heavy_cannon.queue_free()
	
func select_cannon():
	if _type == 0:
		_cannon = $Heavy_cannon
	elif _type == 1:
		_cannon = $Home_cannon
	
func analiseColliderBody():
	if !_cannon.is_colliding():
		return

	if !bodies.size():
		return
		
	var target = _cannon.get_target()
	if target != null && target != bodies[0]:
		var oldBody = bodies[0]
		var newBodyIndex = bodies.find(target)
		bodies[0] = target
		bodies[newBodyIndex] = oldBody

func rotationTurret(delta):
	if !bodies.size():
		return
	var angle = _cannon.get_angle_to(bodies[0].global_position)
	if abs(angle) > .01:
		_cannon.rotation += _cannon.ROTATION_VELOCITY * delta * sign(angle)
	
func set_start_rotation(val):
	start_rotation = val
	if Engine.editor_hint:
		update()

func set_sensor_radius(val):
	sensor_radius = val
	if Engine.editor_hint:
		update()

func _on_Weak_spot_damage(damage, node):
	health -= damage
	$HealthIndicator/HealthSprite.health = float(health) / float(init_health)
	if health <= 0:
		queue_free()
		
func queue_free():
	set_process(false)
	_cannon.queue_free()
	$Weak_spot.queue_free()
	$HealthIndicator.queue_free()
	is_destroying = true
	update()
	$Explode.play()
	$Sprites_explosion.visible = true
	get_tree().call_group("camera", "shake", 5, 1)
	GAME.add_score(POINTS)

func set_type(val):
	_type = val
	if Engine.editor_hint:
		update()
