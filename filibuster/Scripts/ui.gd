extends CanvasLayer

@onready var scoreLabel := $UI/scoreLabel
var score := 0

func addScore():
	score += 1
	scoreLabel.text = "Score: %s" % score
