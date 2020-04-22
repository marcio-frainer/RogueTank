tool
extends Area2D

const ROTATION_VELOCITY = PI * .9

var _bullet = preload("res://Scenes/Turret_01_bullet.tscn")

onready var _sight = $Sight
onready var _smoke = $Smoke
onready var _anime = $Anime
onready var _audio_shoot = $Audio_shoot
onready var _timer_shoot = $Timer

func _ready():
	get_parent().connect("player_entered", self, "on_player_entered")
	get_parent().connect("player_exited", self, "on_player_exited")
	_sight.cast_to = Vector2(get_parent().sensor_radius, 0)
	
func get_target():
	if _sight.is_colliding():
		return _sight.get_collider()
	return null
	
func is_colliding():
	return _sight.is_colliding()	

func on_player_entered(n):
	if !n:
		return
	_sight.enabled = true
	_timer_shoot.start()
	
func on_player_exited(n):
	if n:
		return
	_sight.enabled = false
	_timer_shoot.stop()
	_smoke.emitting = false
	
func shoot():
	var bullet = _bullet.instance()
	bullet.global_position = self.global_position
	bullet.direction = Vector2(cos(rotation), sin(rotation)).normalized()
	bullet.max_distance = get_parent().sensor_radius
	get_parent().get_parent().add_child(bullet)
	_audio_shoot.play()
	_anime.play("Move")
	_smoke.emitting = true

func _on_Timer_timeout():
	if !_sight.is_colliding():
		_smoke.emitting = false
		return
	shoot()
	


