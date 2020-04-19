extends StaticBody2D

const _OIL = preload("res://Scenes/Oil.tscn")
const POINTS = 25

var _count_finished = 1
export(int, 1, 500) var initial_health = 15 setget set_initial_health
var health = initial_health

func _ready():
	$Area_hit.connect("hitted", self, "on_area_hitted")
	$Area_hit.connect("is_destroing", self, "on_is_destroing")
	
func on_area_hitted(damage, node):
	health -= damage
	if health <= 0:
		destroy()
	
func destroy():
	if _count_finished > 1:
		return
	$Audio_explode.play()
	spread_oil()
	_count_finished += 1
	$Anime.play("Destroy")
	$Shape.queue_free()
	yield($Anime, "animation_finished")
	$Area_hit.queue_free()
	GAME.add_score(POINTS)
	queue_free()
	
func spread_oil():
	var qty_oil = rand_range(2, 5)
	
	for r in range(qty_oil):
		var oil = _OIL.instance()
		var angle = randf() * (PI * 2)
		oil.global_position = global_position + Vector2(cos(angle), sin(angle)).normalized() * rand_range(20, 90)
		get_parent().add_child(oil)	

func set_initial_health(val):
	health = val
