extends CanvasLayer

@onready var progress_bar = $Control/ProgressBar
@onready var timer = $Timer

@export var starting_progress = 50
var current_progress : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_progress = starting_progress
	progress_bar.value = current_progress
	timer.start(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = current_progress

func _on_typing_controller_completed_word(word: Variant) -> void:
	current_progress += 1


func _on_timer_timeout() -> void:
	timer.start(1)
	current_progress -= 1
