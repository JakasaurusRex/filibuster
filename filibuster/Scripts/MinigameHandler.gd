extends Node

@onready var minigames := {
	#"fish_game": {
		#"scene": preload("res://Assets/Scenes/Minigames/FishMinigame/FishMinigame.tscn"),
		#"weight": 1
	#},
	#"bullseye": {
		#"scene": preload("res://Assets/Scenes/Minigames/Bullseye/Bullseye.tscn"),
		#"weight": 1
	#},
	#"whack_a_senator": {
		#"scene": preload("res://Assets/Scenes/Minigames/WhackASenator/WhackASenator.tscn"),
		#"weight": 1
	#},
	#"pet_dog": {
		#"scene": preload("res://Assets/Scenes/Minigames/PetDog/pet_dog_minigame.tscn"),
		#"weight": 1
	#},
	#"states": {
		#"scene": preload("res://Assets/Scenes/Minigames/USStates/states.tscn"),
		#"weight": 1
	#},
	#"trashshoot": {
		#"scene": preload("res://Assets/Scenes/Minigames/TrashShoot/TrashShoot.tscn"),
		#"weight": 1
	#},
	#"energydrink": {
		#"scene": preload("res://Assets/Scenes/Minigames/EnergyDrink/EnergyDrink.tscn"),
		#"weight": 1
	#},
	#"matchtwo": {
		#"scene": preload("res://Assets/Scenes/MatchTwo/MatchTwo.tscn"),
		#"weight": 1
	#},
	#"phonecall": {
		#"scene": preload("res://Assets/Scenes/Minigames/PhoneCall/PhoneCall.tscn"),
		#"weight": 1
	#},
	#"bomb": {
		#"scene": preload("res://Assets/Scenes/Minigames/BombGame/bomb_game.tscn"),
		#"weight": 1
	#},
	"airhockey": {
		"scene": preload("res://Assets/Scenes/Minigames/AirHockey/air_hockey.tscn"),
		"weight": 1
	}
}

func get_random_minigame():
	return minigames.keys().pick_random()

func get_minigame_scene(minigame):
	return minigames[minigame]['scene']
