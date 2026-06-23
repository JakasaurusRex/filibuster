extends Node3D
@onready var animationPlayer = $filAnimation
@onready var wordPosition := $wordPosition

func speak_animation():
	animationPlayer.play("speak")
