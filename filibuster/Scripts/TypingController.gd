extends Node
class_name TypingController

var can_type := true

#word animation
var word_animation_scene = preload("res://Assets/Scenes/wordAnimation.tscn")
const TEMP_ANIMATION_POS = Vector2(480, 170)

#var document_words
var current_sentence : String
var current_sentence_tokens : Array
var current_word : String
var current_word_idx : int = 0
var current_document : String
var current_document_tokens : Array
var current_char_idx : int = 0
var word_char_idx : int = 0

var bad_characters := "?!-'()"
var text_box_font
var text_box_font_size
var text_box_length

signal incorrect_letter()
signal correct_letter()
signal completed_word(word)
signal completed_sentence()
	
func load_font_data(label):
	text_box_font = label.get_theme_default_font()
	text_box_font_size = label.get_theme_default_font_size()
	text_box_length = label.size.x - 48
	
# Advance the index into the word
func advance_idx():
	
	# First advance the character
	if(current_sentence[current_char_idx] != " "):
		word_char_idx += 1
	current_char_idx += 1
	emit_signal("correct_letter")
	print(current_word, " ", current_word_idx, " ", word_char_idx, " ", current_word.length())
	# Then lets advance the word
	if word_char_idx == current_word.length():
		word_char_idx = 0
		current_word_idx += 1
		emit_signal("completed_word", current_word)
		animate_word(current_word, TEMP_ANIMATION_POS)
		if current_word_idx < len(current_sentence_tokens):
			current_word = current_sentence_tokens[current_word_idx]

	
	# If we are at the end of the sentence, get new sentence
	if current_char_idx == current_sentence.length():
		current_char_idx = 0
		
		# If we are at the end of the doc, lets get the next doc
		if len(current_document_tokens) == 0:
			DocumentHandler.get_next_document()
			parse_document(DocumentHandler.get_current_file())
		else:
			var current_text = get_line_of_text(current_document_tokens)
			current_sentence = current_text[0]
			current_sentence_tokens = current_text[1]
			current_word_idx = 0
			current_char_idx = 0
		current_word = current_sentence_tokens[0]
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
		#document_words = content.split(" ")
		var current_text = get_line_of_text(current_document_tokens)
		current_sentence = current_text[0]
		current_sentence_tokens = current_text[1]
		current_word = current_sentence_tokens[0]
		current_word_idx = 0
		current_char_idx = 0
		file.close()
		return
	print("File does not exist: ", document_name)
	return

func get_line_of_text(document_tokens):
	var first_token = document_tokens.pop_at(0)
	var text_tokens = [first_token]
	var text_to_add = first_token
	while text_box_font.get_multiline_string_size(text_to_add + " " + document_tokens[0], HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER, -1, text_box_font_size).x < text_box_length:
		var new_token = document_tokens.pop_at(0)
		text_tokens.append(new_token)
		text_to_add += " " + new_token
		if len(document_tokens) == 0:
			break
	if text_to_add[-1] != " ": text_to_add += " "
	print("SENTENCE TOKENS: ", text_tokens)
	return [text_to_add, text_tokens]

func pause_typing(time):
	can_type = false
	await get_tree().create_timer(time).timeout
	can_type = true
	
# Handle keyboard events
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		if not can_type: return
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.keycode]).get_string_from_utf8()
		
		#if key_typed.to_lower() != current_word[current_char_idx].to_lower():
		if key_typed.to_lower() != current_sentence[current_char_idx].to_lower():
			emit_signal("incorrect_letter")
		else:
			advance_idx()
			


# Instantiates word animations given the word and position you would like the animation to be played
func animate_word(word: String, pos: Vector2):
	# Create instance and set the word and positoin of animation
	var word_scene = word_animation_scene.instantiate()
	word_scene.position = pos
	word_scene.set_word(word)
	
	# Add instance to scene and destroy after set time
	add_child(word_scene)
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(word_scene):
		word_scene.queue_free()
