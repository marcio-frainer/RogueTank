tool
extends StaticBody2D

const ROTATION_VELOCITY = PI * .9
const BULLET = preload("res://Scenes/Turret_01_bullet.tscn")
const POINTS = 250

var bodies = []
var first_draw = true
var is_destroying = false

export(float, 0, 360) var start_rotation = 0.0 setget set_start_rotation
export(float, 100, 1000) var sensor_radius = 100.0 setget set_sensor_radius
export var health = 100
onready var init_health = health

func _process(delta):
	rotationTurret(delta)
	analiseColliderBody()

func _on_Sensor_body_entered(body):
	if !bodies.size():
		$Shoot.start()
	bodies.append(body)
	$Cannon/Sight.enabled = true
	update()

func _on_Sensor_body_exited(body):
	var index = bodies.find(body)
	if index != -1:
		bodies.remove(index)
	if !bodies.size():
		$Cannon/Sight.enabled = false
		$Shoot.stop()
		$Cannon/Smoke.emitting = false
	update()

func _on_Timer_timeout():
	if !$Cannon/Sight.is_colliding():
		$Cannon/Smoke.emitting = false
		return
	shoot()

func _draw():
	if is_destroying:
		return
	if first_draw:
		$Cannon.rotation = deg2rad(start_rotation)
		createShape()
		if !Engine.editor_hint:
			first_draw = false
	if bodies.size():
		draw_circle(Vector2(), $Cannon/Sensor/Shape.shape.radius, Color(1, 0, 0, 0.1))
	draw_arc(Vector2(), $Cannon/Sensor/Shape.shape.radius, 0, 360, 1180, Color(1, 0, 0, 0.005), 1)	

func createShape():
	var new_shape = CircleShape2D.new()
	new_shape.radius = sensor_radius
	$Cannon/Sensor/Shape.shape = new_shape
	$Cannon/Sight.cast_to = Vector2(sensor_radius, 0)
	
func shoot():
	var bullet = BULLET.instance()
	bullet.global_position = self.global_position
	bullet.direction = Vector2(cos($Cannon.rotation), sin($Cannon.rotation)).normalized()
	bullet.max_distance = sensor_radius
	get_parent().add_child(bullet)
	$Audio_shoot.play()
	$Anime.play("Move")
	$Cannon/Smoke.emitting = true
	
func analiseColliderBody():
	if !$Cannon/Sight.is_colliding():
		return
	if $Cannon/Sight.get_collider() != bodies[0]:
		var oldBody = bodies[0]
		var newBodyIndex = bodies.find($Cannon/Sight.get_collider())
		bodies[0] = $Cannon/Sight.get_collider()
		bodies[newBodyIndex] = oldBody

func rotationTurret(delta):
	if !bodies.size():
		return
	var angle = $Cannon.get_angle_to(bodies[0].global_position)
	if abs(angle) > .01:
		$Cannon.rotation += ROTATION_VELOCITY * delta * sign(angle)
	
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
	$Audio_hit.play()
	$HealthIndicator/HealthSprite.health = float(health) / float(init_health)
	if health <= 0:
		queue_free()
		
func queue_free():
	set_process(false)
	$Cannon/Sensor.disconnect("body_exited", self, "_on_sensor_body_exited")
	$Cannon/Sensor.queue_free()
	$Cannon.queue_free()
	$Shoot.queue_free()
	$Weak_spot.queue_free()
	$HealthIndicator.queue_free()
	is_destroying = true
	update()
	$Explode.play()
	$Sprites_explosion.visible = true
	get_tree().call_group("camera", "shake", 5, 1)
	GAME.add_score(POINTS)
