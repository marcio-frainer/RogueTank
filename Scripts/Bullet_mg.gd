extends Area2D

var vel = 400
var dir = Vector2()
var alive = true
onready var init_position = self.global_position

func _physics_process(delta):
	if alive:
		translate(dir * vel * delta)
	if global_position.distance_to(init_position) >= 200:
		autodestroy()

func _on_Bullet_mg_body_entered(body):
	if body.collision_layer == 4:
		autodestroy()
	
func autodestroy():
	$Sprite.visible = false
	alive = false
	$Anime.play("Explosion")
	call_deferred("set_monitoring", false)
	call_deferred("set_monitorable", false)
	yield($Anime, "animation_finished")
	queue_free()

const DESTRUCTABLE_LAYER = 32
func _on_Bullet_mg_area_entered(area):
	if area.collision_layer == DESTRUCTABLE_LAYER:
		if area.has_method("hit"):
			area.hit(1, self)
