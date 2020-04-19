extends AnimationPlayer

func _ready():
	pass
	
func change_texture(val):
	print("change_texture 2)
	self.texture = val
	self.vframes = 4
	self.hframes = 3
	
	var walkAnimation = self.get_animation("Shake")
	walkAnimation.add_track(0)
	walkAnimation.length = 0.7
	
	var path = String(self.get_path()) + ":Shake"
	walkAnimation.track_set_path(0, path)
	walkAnimation.track_insert_key(0, 0.0, 0)
	walkAnimation.track_insert_key(0, 0.7, 7)
	walkAnimation.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
	walkAnimation.loop = 1	

func _on_Damage_change_texture(texture):
	print("change_texture 1")
	self.change_texture(texture)
