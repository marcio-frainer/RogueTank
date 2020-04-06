extends Area2D

const ROTATION_VELOCITY = PI * .2
const BULLET = preload("res://Scenes/Turret_01_bullet.tscn")

var bodies = []

func _process(delta):
	rotationTurret(delta)
	analiseColliderBody()

func _on_Sensor_body_entered(body):
	if !bodies.size():
		$Timer.start()
	bodies.append(body)
	$Cannon/Sight.enabled = true

func _on_Sensor_body_exited(body):
	var index = bodies.find(body)
	if index != -1:
		bodies.remove(index)
	if !bodies.size():
		$Cannon/Sight.enabled = false
		$Timer.stop()

func _on_Timer_timeout():
	if !$Cannon/Sight.is_colliding():
		return
	shoot()

func shoot():
	var bullet = BULLET.instance()
	bullet.global_position = global_position
	bullet.direction = Vector2(cos($Cannon.rotation), sin($Cannon.rotation)).normalized()
	get_parent().add_child(bullet)
	$Audio_shoot.play()
	$Anime.play("Move")
	
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
	if abs(angle) > .1:
		$Cannon.rotation += ROTATION_VELOCITY * delta * sign(angle)
	
