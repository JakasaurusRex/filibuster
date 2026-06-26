extends "res://Scripts/Minigames/minigame_template_2d.gd"
## How many times you must click to win game
@export var total_drink: int = 50
@onready var num_drinked = 0
@onready var animation_player = $AnimationPlayer
@onready var drink_progress_bar = $CanvasLayer/DrinkProgress
@onready var bottle = $BottledWater
@onready var particles = $ScoreParticles

func _ready() -> void:
	drink_progress_bar.max_value = total_drink
	drink_progress_bar.value = total_drink

func _on_drink_button_pressed() -> void:
	num_drinked += 1
	AudioHandler.playSound("EnergyDrink")
	drink_progress_bar.value -= 1
	animation_player.play("drink")
	if num_drinked >= total_drink:
		win()
		animation_player.play("win")
		particles.emitting = true
		get_tree().create_timer(2).timeout.connect(close)
