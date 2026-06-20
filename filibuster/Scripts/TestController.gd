extends Node

@onready var label = $"../UILayer/UI/textBoxPanel/textLabel"
@onready var type_controller = $"../TypingController"
@onready var bee = "res://Assets/Documents/bee.txt"

var last_incorrect = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type_controller.load_font_data(label)
	type_controller.parse_document(bee)
	label.text = type_controller.current_sentence
	
func _on_typing_controller_completed_word() -> void:
	label.text = type_controller.current_sentence
	last_incorrect = -1


func _on_typing_controller_correct_letter() -> void:
	var open_green = "[color=green]"
	var end_green =  "[/color]"
	#var current_word = type_controller.current_word
	var current_sentence = type_controller.current_sentence
	var current_char_idx = type_controller.current_char_idx
	
	#var highlighted_green = current_word.substr(0, current_char_idx)
	#var non_highlighted = current_word.substr(current_char_idx)
	
	var highlighted_green = current_sentence.substr(0, current_char_idx)
	var non_highlighted = current_sentence.substr(current_char_idx)
	
	label.text = open_green + highlighted_green + end_green + non_highlighted
	

func _on_typing_controller_incorrect_letter() -> void:
	var open_red = "[color=red]"
	var end_red =  "[/color]"
	var current_char_idx = type_controller.current_char_idx
	if current_char_idx == last_incorrect:
		return
	last_incorrect = current_char_idx
	
	var current_label_text = label.text

	var current_label_idx = current_label_text.find("[/color]")
	if current_label_idx == -1:
		current_label_idx = 0
	else:
		current_label_idx += 8
	
	var no_change = ""
	if current_label_idx != 0:
		no_change = current_label_text.substr(0, current_label_idx)
	var red_text = open_red + current_label_text[current_label_idx] + end_red
	var no_change2 = current_label_text.substr(current_label_idx + 1)
	
	label.text = no_change + red_text + no_change2
