extends Node2D

@onready var deathTimer := $deathTimer

func _ready() -> void:
	deathTimer.timeout.connect(queue_free)
	
func set_word(word):
	var label = get_node("RigidBody2D/wordLabel")
	label.text = word
