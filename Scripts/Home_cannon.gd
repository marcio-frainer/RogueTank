extends Area2D

const ROTATION_VELOCITY = PI * .1
var _missil = preload("res://Scenes/Home_missil.tscn")

onready var _fire_timer = $Fire_timer
onready var _initial_fire = $Initial_fire
onready var _sound_fire = $Audio
onready var _anime = $Anime
onready var _smoke = $Smoke

func _ready():
	pass 

func is_colliding():
	return true

func get_target():
	var tank = get_parent().bodies[0]
	var ht = (tank.global_position - global_position).normalized()
	var facing = Vector2(cos(rotation), sin(rotation))

	if ht.dot(facing) > .5:
		if _fire_timer.is_stopped():
			fire()
			_fire_timer.start()
	else:
		_fire_timer.stop()
		
	return tank

func fire():
	if !get_parent().bodies.size():
		_fire_timer.stop()
		_smoke.emitting = false
		return
	_sound_fire.play()
	_anime.play("Move")
	_smoke.emitting = true
	var missil = _missil.instance()
	get_parent().add_child(missil)
	missil.rotation = rotation
	missil.target = get_parent().bodies[0]
	missil.global_position = _initial_fire.global_position

func _on_Fire_timer_timeout():
	fire()
