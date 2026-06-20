extends Node
class_name TypingController

var document_words

var current_sentence
var current_word
var current_word_idx

var current_char_idx 

signal incorrect_letter()
signal correct_letter()
signal completed_word()

# Advance the index into the word
func advance_idx():
	current_char_idx += 1
	emit_signal("correct_letter")
	if current_char_idx == current_word.length():
		current_char_idx = 0
		current_word_idx += 1
		current_word = document_words[current_word_idx]
		emit_signal("completed_word")

# Read the file and split words into document_words
func parse_document(document_name: String):
	if not FileAccess.file_exists(document_name):
		print("File does not exist: ", document_name)
		return
	var file = FileAccess.open(document_name, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		document_words = content.split(" ")
		current_word = document_words[0]
		current_word_idx = 0
		current_char_idx = 0
		file.close()
		return
	print("File does not exist: ", document_name)
	return

# Handle keyboard events
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.keycode]).get_string_from_utf8()
		
		if key_typed.to_lower() != current_word[current_char_idx].to_lower():
			emit_signal("incorrect_letter")
		else:
			advance_idx()
			
		
		
