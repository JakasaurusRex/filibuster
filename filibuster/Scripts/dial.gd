extends CanvasLayer

@onready var progress_bar = $progressDialMargins/ProgressBar
@onready var game_manager = $"../GameManager"

signal dial_empty()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = game_manager.current_rating
	print(progress_bar.value)
	if progress_bar.value == 0:
		emit_signal("dial_empty")
