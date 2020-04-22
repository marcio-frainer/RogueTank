extends StaticBody2D

const POINTS = 125
var initial_health = 50

var textures = [
	"res://original/sprites/crateMetal.png",
	"res://original/sprites/crateMetal_damage_1.png",
	"res://original/sprites/crateMetal_damage_2.png",
	"res://original/sprites/crateMetal_damage_3.png"	
	]

func queue_free():
	$Area_destructable.queue_free()
	$Sprite.queue_free()
	$Explosion.play()
	$Collision.queue_free()
	yield($Explosion/Anime, "animation_finished")
	$Explosion.queue_free()
	GAME.add_score(POINTS)
	.queue_free()

func _on_Area_destructable_destroid():
	queue_free()

func _on_Area_destructable_hitted(damage, health, node):
	var perc = health * 100 / initial_health
	if perc > 80:
		$Sprite.texture = load(textures[0])
	elif perc > 60 && perc < 80:
		$Sprite.texture = load(textures[1])
	elif perc > 30 && perc < 60:	
		$Sprite.texture = load(textures[2])
	elif perc < 30:
		$Sprite.texture = load(textures[3])	
