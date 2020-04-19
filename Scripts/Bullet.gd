extends Area2D

const SPEED = 400
var max_distance = 280
var dir = Vector2(0, -1) setget set_dir

onready var init_pos = global_position
onready var alive = true

func _ready():
	pass 

func _physics_process(delta):
	if alive:
		if global_position.distance_to(init_pos) >= max_distance:
			autodestroy()
		translate(dir * SPEED * delta)

func _on_Notifier_screen_exited():
	queue_free()

func set_dir(val):
	dir = val
	rotation = dir.angle()

func _on_Bullet_body_entered(body):
	# 2, 4 e 32
	if body.collision_layer == 2 || body.collision_layer == 4 || body.collision_layer == 32:
		autodestroy()

func autodestroy():
	$Smoke.emitting = false
	alive = false
	$Sprite.visible = false
	$Anime.play("Explosion")
	call_deferred("set_monitoring", false)
	call_deferred("set_monitorable", false)
	yield($Anime, "animation_finished")
	queue_free()

const DESTRUCTABLE_LAYER = 32
const ENEMY_LAYER = 2
func _on_Bullet_area_entered(area):
	if area.collision_layer == DESTRUCTABLE_LAYER || area.collision_layer == ENEMY_LAYER:
		if area.has_method("hit"):
			area.hit(10, self)
