tool
extends Node2D

func play():
	$Anime.play()
	$Audio_damage.play()
	
func queue_free():
	$Sprite.queue_free()
	$Audio_damage.queue_free()
	.queue_free()
