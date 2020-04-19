extends Camera2D

var intensity
var angle_rotation = 0

func _ready():
	set_process(false)
	add_to_group("camera")

func _process(delta):
	angle_rotation += PI / 2
	offset = Vector2(cos(angle_rotation), sin(angle_rotation)) * intensity

func shake(intensity, duration):
	set_process(true)
	self.intensity = intensity
	get_tree().create_timer(duration).connect("timeout", self, "on_timeout")
	
func on_timeout():
	set_process(false)	
