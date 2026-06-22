extends Node

enum GameState {
	PLAYING,
	GAME_OVERING,
	GAME_OVER,
}

@onready var minigame_subviewport_container := $"../Control/HBoxContainer/MinigameSubViewportContainer"
@onready var minigame_subviewport := $"../Control/HBoxContainer/MinigameSubViewportContainer/MinigameSubviewPort"
var rolling_out_mini_game = false
var roll_out_speed = 0.5
var rolling_off_mini_game = false
const fish_minigame = preload("res://Assets/Scenes/Minigames/FishMinigame/FishMinigame.tscn")

@onready var game_over_timer = $GameOverTimer
@export var game_over_time = 1

var current_state = GameState.PLAYING

func _ready() -> void:
	current_state = GameState.PLAYING
	minigame_subviewport_container.size_flags_stretch_ratio = 0
	minigame_subviewport_container.visible = false
	spawn_minigame()

func _process(delta: float) -> void:
	if current_state == GameState.GAME_OVER:
		get_tree().quit()
	if rolling_out_mini_game == true:
		minigame_subviewport_container.size_flags_stretch_ratio = lerpf(minigame_subviewport_container.size_flags_stretch_ratio, 100, roll_out_speed * delta) 
	elif rolling_off_mini_game == true:
		minigame_subviewport_container.size_flags_stretch_ratio = lerpf(minigame_subviewport_container.size_flags_stretch_ratio, 0, roll_out_speed * delta)
		if minigame_subviewport_container.size_flags_stretch_ratio < 20:
			minigame_subviewport_container.visible = false

func on_dial_empty() -> void:
	current_state = GameState.GAME_OVERING
	game_over_timer.start(game_over_time)

func on_timer_timeout() -> void:
	current_state = GameState.GAME_OVER
	
func spawn_minigame() -> void:
	minigame_subviewport_container.visible = true
	var fish_minigame_instance = fish_minigame.instantiate()
	fish_minigame_instance.completed.connect(on_minigame_complete)
	minigame_subviewport.add_child(fish_minigame_instance)
	rolling_out_mini_game = true
	
	
	
func on_minigame_complete():
	rolling_off_mini_game = true
	rolling_out_mini_game = false
	
