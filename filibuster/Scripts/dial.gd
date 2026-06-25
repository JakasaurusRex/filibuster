extends CanvasLayer

@onready var progress_bar = $progressDialMargins/ProgressBar
@onready var game_manager = $"../GameManager"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = game_manager.current_rating
