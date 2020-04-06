extends StaticBody2D

var textures = [
	"res://original/sprites/crateMetal.png",
	"res://original/sprites/crateMetal_damage_1.png",
	"res://original/sprites/crateMetal_damage_2.png",
	"res://original/sprites/crateMetal_damage_3.png"	
	]

func _ready():
	$Area_destructable.connect("hitted", self, "on_area_hitted")
	$Area_destructable.connect("is_destroing", self, "on_is_destroing")
	
func on_area_hitted(damage, initial_health, health, node):
	var perc = health * 100 / initial_health
	if perc > 80:
		$Sprite.texture = load(textures[0])
	elif perc > 60 && perc < 80:
		$Sprite.texture = load(textures[1])
	elif perc > 30 && perc < 60:	
		$Sprite.texture = load(textures[2])
	elif perc < 30:
		$Sprite.texture = load(textures[3])	
		
	if damage > 5:	
		$Anime_damage.play("Damage")
	else:
		$Anime_damage.play("small_damage")	
	
func on_is_destroing():
	$Sprite.visible = false
	$Anime_destroy.play("Destroy")
	yield($Anime_destroy, "animation_finished")
	queue_free()
	

