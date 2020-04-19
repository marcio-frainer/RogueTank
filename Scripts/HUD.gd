extends CanvasLayer

func _ready():
	GAME.connect("score_changed", self, "on_score_changed")

func on_score_changed():
	$Score.text = "Score : " + str(GAME.score)
