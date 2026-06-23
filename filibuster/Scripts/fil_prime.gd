extends Node3D
@onready var animationPlayer = $filAnimation

func speak_animation():
	animationPlayer.play("speak")
