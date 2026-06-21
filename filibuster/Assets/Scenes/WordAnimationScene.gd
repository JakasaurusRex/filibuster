extends Node2D

func set_word(word):
	var label = get_node("RigidBody2D/wordLabel")
	label.text = word
