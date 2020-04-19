extends StaticBody2D

const POINTS = 45
var initial_health = 20
var health = initial_health

var textures = [
	"res://original/sprites/crateWood.png",
	"res://original/sprites/crateWood_damage_1.png",
	"res://original/sprites/crateWood_damage_2.png",
	"res://original/sprites/crateWood_damage_3.png"	
	]

func _ready():
	$Area_destructable.connect("hitted", self, "on_area_hitted")
	
func on_area_hitted(damage, node):
	health -= damage
	if health <= 0:
		queue_free()

	var perc = health * 100 / initial_health
	
	if perc > 80:
		$Sprite.texture = load(textures[0])
	elif perc > 60 && perc < 80:
		$Sprite.texture = load(textures[1])
	elif perc > 30 && perc < 60:	
		$Sprite.texture = load(textures[2])
	elif perc < 30:
		$Sprite.texture = load(textures[3])	

func queue_free():
	$Area_destructable.queue_free()
	$Sprite.queue_free()
	$Explosion.play()
	$Collision.queue_free()
	yield($Explosion/Anime, "animation_finished")
	$Explosion.queue_free()
	GAME.add_score(POINTS)
	.queue_free()
	

