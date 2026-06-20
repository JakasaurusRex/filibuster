extends Node
class_name TypingController

var document_words

var current_sentence : String
var current_word : String
var current_word_idx : int = 0
var current_document : String
var current_document_tokens : Array
var current_char_idx : int = 0

var bad_characters := "?!-'()"
var text_box_font
var text_box_font_size
var text_box_length

signal incorrect_letter()
signal correct_letter()
signal completed_word()
signal completed_sentence()
	
func load_font_data(label):
	text_box_font = label.get_theme_default_font()
	text_box_font_size = label.get_theme_default_font_size()
	text_box_length = label.size.x - 48
	
# Advance the index into the word
func advance_idx():
	current_char_idx += 1
	emit_signal("correct_letter")
	#if current_char_idx == current_word.length():\
	if current_char_idx == current_sentence.length():
		current_char_idx = 0
		current_word_idx += 1
		if len(current_document_tokens) == 0: #finished current document
			DocumentHandler.get_next_document()
			parse_document(DocumentHandler.get_current_file())
		current_sentence = get_line_of_text(current_document_tokens)
		current_word = document_words[current_word_idx]
		emit_signal("completed_sentence")

# Read the file and split words into document_words
func parse_document(document_name: String):
	if not FileAccess.file_exists("res://Assets/Documents/%s" % document_name):
		print("File does not exist: ", document_name)
		return
	var file = FileAccess.open("res://Assets/Documents/%s" % document_name, FileAccess.READ)
	if file: 
		print("loaded file %s" % document_name)
		var content = file.get_as_text()
		content = content.remove_chars(bad_characters).replace("\n", " ").to_lower()
		current_document_tokens = content.split(" ")
		document_words = content.split(" ")
		current_sentence = get_line_of_text(current_document_tokens)
		current_word = document_words[0]
		current_word_idx = 0
		current_char_idx = 0
		file.close()
		return
	print("File does not exist: ", document_name)
	return

func get_line_of_text(document_tokens):
	var text_to_add = document_tokens.pop_at(0)
	while text_box_font.get_multiline_string_size(text_to_add + " " + document_tokens[0], HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER, -1, text_box_font_size).x < text_box_length:
		text_to_add += " " + document_tokens.pop_at(0)
		if len(document_tokens) == 0:
			break
	if text_to_add[-1] != " ": text_to_add += " "
	print(text_to_add[-1])
	return text_to_add
	
# Handle keyboard events
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.keycode]).get_string_from_utf8()
		
		#if key_typed.to_lower() != current_word[current_char_idx].to_lower():
		if key_typed.to_lower() != current_sentence[current_char_idx].to_lower():
			emit_signal("incorrect_letter")
		else:
			advance_idx()
			
		
		
