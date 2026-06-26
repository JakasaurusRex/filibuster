extends Node

class_name Minigame

@export var minigame_size := Vector2(192, 192)
@export var max_runtime := 5.0

signal completed(completion_event)
signal failed(failure_event)
signal closed

#for checking to see if we've won/lost to prevent
#closing game during a win/lose animation due to timeout
var is_done := false

func start():
	get_tree().create_timer(max_runtime).timeout.connect(minigame_timed_out)
	
#when you win the game
func win():
	is_done = true

#when you lose the game
func lose():
	is_done = true
	
#when you run out of time on the minigame
func minigame_timed_out():
	print("Minigame timed out")
	if not is_done:
		emit_signal("failed", null)
		close()

#closing the minigame after winning/losing
func close():
	emit_signal("closed")
	queue_free()
	
