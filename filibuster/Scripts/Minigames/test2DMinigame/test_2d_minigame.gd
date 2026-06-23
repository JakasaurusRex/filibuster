extends Minigame

@onready var winButton := $testButton

func _ready() -> void:
	winButton.pressed.connect(win)
	
func win():
	emit_signal("completed", "FINISHED TEST GAME")
	close()
	
