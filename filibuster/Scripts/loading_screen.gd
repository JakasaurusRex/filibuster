extends CanvasLayer

signal loading_screen_ready

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var progress_bar = $Panel/ProgressBar

func _ready() -> void:
	await anim.animation_finished
	loading_screen_ready.emit()

func _on_progress_changed(new_value: float) -> void:
	progress_bar.value = new_value * 100

func _on_load_finished() -> void:
	anim.play_backwards("transition")
	await anim.animation_finished
	queue_free()
