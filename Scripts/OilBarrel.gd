extends StaticBody2D

const _OIL = preload("res://Scenes/Oil.tscn")

var _count_finished = 1

func _ready():
	$Area_hit.connect("hitted", self, "on_area_hitted")
	$Area_hit.connect("is_destroing", self, "on_is_destroing")
	
func on_area_hitted(damage, initial_health, health, node):
	pass
	
func on_is_destroing():
	if _count_finished > 1:
		return
	spread_oil()
	_count_finished += 1
	$Anime.play("Destroy")
	$Shape.queue_free()
	yield($Anime, "animation_finished")
	queue_free()
	
func spread_oil():
	var qty_oil = rand_range(2, 5)
	
	for r in range(qty_oil):
		var oil = _OIL.instance()
		var angle = randf() * (PI * 2)
		oil.global_position = global_position + Vector2(cos(angle), sin(angle)).normalized() * rand_range(20, 90)
		get_parent().add_child(oil)	
