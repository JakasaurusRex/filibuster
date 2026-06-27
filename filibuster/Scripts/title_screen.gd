extends Node3D

@export var main_scene: StringName = &""
@onready var anim = $AnimationPlayer
@onready var title_buttons = $MainMenu/TitleButtons

func _on_play_button_pressed() -> void:
	AudioHandler.playSound("ui_click")
	if not anim.is_playing():
		SceneLoader.load_scene(main_scene)

func _on_credits_button_pressed() -> void:
	AudioHandler.playSound("ui_click")
	if not anim.is_playing():
		anim.play("credits")

func _on_credit_back_button_pressed() -> void:
	AudioHandler.playSound("ui_click")
	if not anim.is_playing():
		anim.play_backwards("credits")
