extends Node2D

func _ready():
	$Timer.wait_time = rand_range(8, 16)
	$Timer.start()
	
func _on_Timer_timeout():
	$Anime.play("Fade")
	yield($Anime, "animation_finished")
	queue_free()
