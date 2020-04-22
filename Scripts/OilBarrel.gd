extends StaticBody2D

const _OIL = preload("res://Scenes/Oil.tscn")
const POINTS = 25

var _count_finished = 1
var initial_health = 15

func queue_free():
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
	.queue_free()
	
func spread_oil():
	var qty_oil = rand_range(2, 5)
	
	for r in range(qty_oil):
		var oil = _OIL.instance()
		var angle = randf() * (PI * 2)
		oil.global_position = global_position + Vector2(cos(angle), sin(angle)).normalized() * rand_range(20, 90)
		get_parent().add_child(oil)

func _on_Area_hit_destroid():
	queue_free()
