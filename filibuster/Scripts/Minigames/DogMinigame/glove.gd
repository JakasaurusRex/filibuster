extends Node3D

@onready var glove1 = $Glove
@onready var glove2 = $Glove2

var grabbing = false

func _process(delta: float) -> void:
	glove1.visible = !grabbing
	glove2.visible = grabbing

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		grabbing = true
	elif Input.is_action_just_released("left_mouse"):
		grabbing = false
