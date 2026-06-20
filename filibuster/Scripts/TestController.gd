extends Node

@onready var label = $"../UILayer/UI/textBoxPanel/textLabel"
@onready var type_controller = $"../TypingController"

@export var success_color : Color
@export var failure_color : Color
@export var cursor_color : Color

var open_red
var close_red
var open_green
var close_green
var open_cursor
var close_cursor

var last_incorrect = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DocumentHandler.get_specific_document("tiny_test")
	type_controller.load_font_data(label)
	type_controller.parse_document(DocumentHandler.get_current_file())
	label.text = type_controller.current_sentence
	open_red = "[color=%s]" % failure_color.to_html()
	close_red = "[/color]"
	open_green = "[color=%s]" % success_color.to_html()
	close_green = "[/color]"
	open_cursor = "[bgcolor=%s]" % cursor_color.to_html()
	close_cursor = "[/bgcolor]"
	
func _on_typing_controller_completed_sentence() -> void:
	label.text = type_controller.current_sentence
	last_incorrect = -1
	
func _on_typing_controller_correct_letter() -> void:
	var current_sentence = type_controller.current_sentence
	var current_char_idx = type_controller.current_char_idx
	
	var highlighted_green = current_sentence.substr(0, current_char_idx)
	var current_character = current_sentence.substr(current_char_idx, 1)
	var non_highlighted = current_sentence.substr(current_char_idx+1)
	
	label.text = open_green + highlighted_green + close_green + open_cursor + current_character + close_cursor + non_highlighted
	

func _on_typing_controller_incorrect_letter() -> void:
	var current_char_idx = type_controller.current_char_idx
	if current_char_idx == last_incorrect:
		return
	last_incorrect = current_char_idx
	
	var current_label_text = label.get_parsed_text()
	var no_change_begin =  open_green + current_label_text.substr(0, current_char_idx) + close_green
	var red_text = open_red + open_cursor + current_label_text[current_char_idx] + close_cursor + close_red
	var no_change_end = current_label_text.substr(current_char_idx + 1)
	
	label.text = no_change_begin + red_text + no_change_end
