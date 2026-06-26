extends Minigame

func _ready() -> void:
	pass
	
func win():
	super.win()
	emit_signal("completed", "PLAYER WON TEMPLATE GAME")
	close()

func lose():
	super.lose()
	emit_signal("failed", "PLAYER LOST TEST GAME")
	close()
