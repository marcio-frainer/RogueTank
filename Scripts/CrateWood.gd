extends StaticBody2D

const POINTS = 45
var _fragments = preload("res://Scenes/fragments/box_fragments.tscn")
onready var initial_health = 30

var textures = [
	"res://original/sprites/crateWood.png",
	"res://original/sprites/crateWood_damage_1.png",
	"res://original/sprites/crateWood_damage_2.png",
	"res://original/sprites/crateWood_damage_3.png"	
	]

func queue_free():
	deleteComposition()
	showFragments()
	defineScores()
	#call super
	.queue_free()

func deleteComposition():
	$Area_destructable.queue_free()
	$Sprite.visible = false
	$Collision.queue_free()

func showFragments():
	var fragments = _fragments.instance()
	fragments.global_position = global_position
	get_parent().add_child(fragments)

func defineScores():
	GAME.add_score(POINTS)

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
