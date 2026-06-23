extends Node

class_name Minigame

@export var minigame_size := Vector2(192, 192)
@export var max_runtime := 5.0

signal completed(completion_event)
signal failed(failure_event)
signal closed

func start():
	get_tree().create_timer(max_runtime).timeout.connect(minigame_timed_out)
	
#when you win the game
func win():
	pass

#when you lose the game
func lose():
	pass
	
#when you run out of time on the minigame
func minigame_timed_out():
	emit_signal("failed", null)
	close()

#closing the minigame after winning/losing
func close():
	emit_signal("closed")
	queue_free()
	
