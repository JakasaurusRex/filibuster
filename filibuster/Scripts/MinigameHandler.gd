extends Node

@onready var minigames := {
	"test_2d_minigame" : {
		"scene": preload("res://Assets/Scenes/Minigames/test2DMinigame/test_2d_minigame.tscn"),
		"weight": 1
	},
	"fish_game": {
		"scene": preload("res://Assets/Scenes/Minigames/FishMinigame/FishMinigame.tscn"),
		"weight": 1
	},
	"bullseye": {
		"scene": preload("res://Assets/Scenes/Minigames/Bullseye/Bullseye.tscn"),
		"weight": 1
	}
}

func get_random_minigame():
	return minigames.keys().pick_random()

func get_minigame_scene(minigame):
	return minigames[minigame]['scene']
