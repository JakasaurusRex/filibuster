extends Node

enum GameState {
	PLAYING,
	GAME_OVERING,
	GAME_OVER,
}

@onready var game_over_timer = $GameOverTimer
@export var game_over_time = 1

var current_state = GameState.PLAYING

func _ready() -> void:
	current_state = GameState.PLAYING

func _process(delta: float) -> void:
	if current_state == GameState.GAME_OVER:
		get_tree().quit()

func on_dial_empty() -> void:
	current_state = GameState.GAME_OVERING
	game_over_timer.start(game_over_time)

func on_timer_timeout() -> void:
	current_state = GameState.GAME_OVER
	
func spawn_minigame() -> void:
	pass
