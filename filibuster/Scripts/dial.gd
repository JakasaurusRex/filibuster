extends CanvasLayer

@onready var progress_bar = $progressDialMargins/ProgressBar
@onready var game_manager = $"../GameManager"

func _ready() -> void:
	progress_bar.max_value = game_manager.MAX_RATING
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = game_manager.current_rating
