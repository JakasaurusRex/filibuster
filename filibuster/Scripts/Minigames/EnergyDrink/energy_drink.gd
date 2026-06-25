extends "res://Scripts/Minigames/minigame_template_2d.gd"
## How many times you must click to win game
@export var total_drink: int = 50
@onready var num_drinked = 0
@onready var animation_player = $AnimationPlayer

func _on_drink_button_pressed() -> void:
	print("DRINKING!!!!")
	num_drinked += 1
	animation_player.play("drink")
	print("HEYEY HHEYY HEYYH HEYY")
	if num_drinked >= total_drink:
		win()
		close()
