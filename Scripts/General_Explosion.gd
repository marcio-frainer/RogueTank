extends Node2D

func play():
	$Anime.play("Explosion")
	$Audio_explosion.play()

func queue_free():
	$Sprite.queue_free()
	$Audio_explosion.queue_free()
	.queue_free()
