tool
extends KinematicBody2D

# Constants
const SPEED = 100
const MAX_SPEED = 100
const ZOOM_UP_LIMIT = 1;
const ZOOM_DOWN_LIMIT = 40;
const VELOCITY_ROTATION = PI / 2

# Dynamic scenes
var _bullet = preload("res://Scenes/Bullet.tscn")
var _track = preload("res://Scenes/Track.tscn")
var _bullet_mg = preload("res://Scenes/Bullet_mg.tscn")

# onready variables
onready var tank_bullet_obj = str(self)

# global variables
var tank_direction = 0
var	tank_rotation = 0
var tank_aceleration = 0
var deslocated = 0
var tank_velicity_modify
var bullet_loaded = true

# variables exports
export (int, "bigRed", "blue", "dark", "darkLarge", "green", "huge", "red", "sand") var tank_body = 0 setget set_tank_body
export (int, "specialBarrel5", "specialBarrel6", "specialBarrel7", "tankBlue_barrel1", "tankBlue_barrel2", "tankBlue_barrel3", "tankDark_barrel1", "tankDark_barrel2", "tankDark_barrel3", "tankGreen_barrel1", "tankGreen_barrel2", "tankGreen_barrel3", "tankRed_barrel1", "tankRed_barrel2") var tank_barrel = 0 setget set_tank_barrel

# signals
signal cannon_shooted
signal mg_shooted

var tank_bodies = [
	"res://original/sprites/tankBody_bigRed.png",
	"res://original/sprites/tankBody_blue.png",
	"res://original/sprites/tankBody_dark.png",
	"res://original/sprites/tankBody_darkLarge.png",
	"res://original/sprites/tankBody_green.png",
	"res://original/sprites/tankBody_huge.png",
	"res://original/sprites/tankBody_red.png",
	"res://original/sprites/tankBody_sand.png"
	]

var tank_barrels = [
	"res://original/sprites/specialBarrel5.png",
	"res://original/sprites/specialBarrel6.png",
	"res://original/sprites/specialBarrel7.png",
	"res://original/sprites/tankBlue_barrel1.png",
	"res://original/sprites/tankBlue_barrel2.png",
	"res://original/sprites/tankBlue_barrel3.png",
	"res://original/sprites/tankDark_barrel1.png",
	"res://original/sprites/tankDark_barrel2.png",
	"res://original/sprites/tankDark_barrel3.png",
	"res://original/sprites/tankGreen_barrel1.png",
	"res://original/sprites/tankGreen_barrel2.png",
	"res://original/sprites/tankGreen_barrel3.png",
	"res://original/sprites/tankRed_barrel1.png",
	"res://original/sprites/tankRed_barrel2.png"
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	$Sprite.texture = load(tank_bodies[tank_body])
	$Barrel/Sprite.texture = load(tank_barrels[tank_barrel])
	
func _physics_process(delta):
	
	if Engine.editor_hint:
		return
	
	tank_velicity_modify = 1
	if get_tree().get_nodes_in_group(str(self) + "-oil").size() > 0:
		tank_velicity_modify = .3
		
	inputPlayerControl()	
	inputShootControl()

	$Barrel.look_at(get_global_mouse_position())	
	
	rotate(VELOCITY_ROTATION * tank_rotation * delta)
	
	if tank_direction != 0:
		tank_aceleration = lerp(tank_aceleration, MAX_SPEED * tank_direction, .03)
	else:
		tank_aceleration = lerp(tank_aceleration, 0, .03)
		
	var move = move_and_slide(Vector2(cos(rotation), sin(rotation)) * tank_aceleration * tank_velicity_modify)
	
	deslocated += move.length() * delta
	
	addTrack()	
	
func set_tank_body(val):
	tank_body = val
	if Engine.editor_hint:
		update()
	
func set_tank_barrel(val):
	tank_barrel = val
	if Engine.editor_hint:
		update()

func _on_bullet_reload_timeout():
	bullet_loaded = true
	$Barrel/Sight.update()

func inputPlayerControl():
	tank_rotation = 0
	tank_direction = 0

	if Input.is_action_pressed("ui_left"):
		tank_rotation -= 1

	if Input.is_action_pressed("ui_right"):
		tank_rotation += 1
		
	if Input.is_action_pressed("ui_up"):
		tank_direction += 1

	if Input.is_action_pressed("ui_down"):
		tank_direction -= 1

func executeBullet():
	var bullet = _bullet.instance()
	bullet.add_to_group(tank_bullet_obj)
	bullet.global_position = $Barrel/Pos_Bullet.global_position
	bullet.dir = Vector2( cos($Barrel.global_rotation), sin($Barrel.global_rotation) ).normalized()
	bullet.max_distance = $Barrel/Sight.position.x - $Barrel/Pos_Bullet.position.x
	bullet_loaded = false
	$Barrel/Sight.update()
	$bullet_reload.start()
	get_parent().add_child(bullet)
	$Barrel/Shoot.play("Shoot")
	emit_signal("cannon_shooted")
	
func inputShootControl():
	if Input.is_action_just_pressed("ui_shoot") && bullet_loaded:
		if get_tree().get_nodes_in_group(tank_bullet_obj).size() < 6:
			$Barrel/Anime.stop()
			executeBullet()
			$Barrel/Anime.play("Fire")

	if Input.is_action_just_pressed("Shoot_Minigun"):
		$Timer_mg.start()

	if Input.is_action_just_released("Shoot_Minigun"):
		$Timer_mg.stop()
		
func addTrack():
	if deslocated >= $Sprite.texture.get_size().y:
		deslocated = 0
		var track = _track.instance()
		track.global_position = self.global_position
		track.rotation = self.rotation
		track.z_index = self.z_index - 1
		get_parent().add_child(track)

func _on_Timer_mg_timeout():
	ShootMinigun()
	
func ShootMinigun():
	var bullet_mg = _bullet_mg.instance()
	bullet_mg.global_position = $Pos_Mg.global_position
	bullet_mg.global_rotation = global_rotation
	bullet_mg.dir = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	get_parent().add_child(bullet_mg)
	emit_signal("mg_shooted")
