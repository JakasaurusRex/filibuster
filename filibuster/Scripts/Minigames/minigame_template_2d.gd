extends Minigame

func _ready() -> void:
	pass
	
func win():
	super.win()
	emit_signal("completed", "PLAYER WON TEMPLATE GAME")

func lose():
	super.lose()
	emit_signal("finished", "PLAYER LOST TEST GAME")
	
