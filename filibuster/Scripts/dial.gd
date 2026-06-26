extends CanvasLayer

@export var green_color : Color
@export var red_color : Color
@onready var inner_bar : StyleBoxFlat
@onready var progress_bar = $progressDialMargins/ProgressBar
@onready var game_manager = $"../GameManager"

func _ready() -> void:
	inner_bar = progress_bar.get("theme_override_styles/fill")
	progress_bar.max_value = game_manager.MAX_RATING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = game_manager.current_rating
	var ratio = progress_bar.value/progress_bar.max_value
	inner_bar.bg_color = (green_color*ratio) + red_color*(1.0-ratio)
