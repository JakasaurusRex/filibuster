extends Node2D

@onready var deathTimer := $deathTimer
@onready var label := $RigidBody2D/wordLabel
func _ready() -> void:
	deathTimer.timeout.connect(queue_free)
	
func set_word(word):
	var label = get_node("RigidBody2D/wordLabel")
	label.text = word
	
func set_incorrect_material():
	var incorrect_color = Color("ff0034")
	label.add_theme_color_override("font_color", incorrect_color)
