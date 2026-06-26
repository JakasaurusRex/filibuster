extends CanvasLayer


@onready var fil = $"../FilPrime"
@onready var camera := $"../Camera3D"
## UI CONTROLLING CODE
@onready var scoreLabel := $UI/scoreLabel
var score := 0

func addScore():
	score += 1
	scoreLabel.text = "Score: %s" % score

@onready var label = $UI/UIMargins/textBoxPanel/textLabel
@onready var animalese_player = $AnimalesePlayer
@export var success_color : Color
@export var failure_color : Color
@export var cursor_color : Color

## INPUT HANDLING

var can_type := true

#word animation
var word_animation_scene = preload("res://Assets/Scenes/2DWordAnimation.tscn")
var word_animation_scene3D = preload("res://Assets/Scenes/3DWordAnimation.tscn")
const text_box_max_characters := 36.0
const STUTTERS := [
	"Uh...",
	"Erm...",
	"...",
	"Like...",
	"Buh...",
	"Let me think...",
	"FUCK",
	"Um...",
	"So...",
	"Well..."
]

const TRANSITIONS := [
	"In the sense that...",
	"What I mean is...",
	"Therefore...",
	"However...",
	"Within the context of...",
	"Yet, we must also understand that...",
	"And by the pythagorean theorem...",
	"Like my mom always said...",
	"Let alone the subject of...",
	"What really strikes me is...",
	"Still...",
	"Moving on...",
	"As history will tell you...",
	"But we mustn't forget...",
	"On the other hand...",
	"Back to my main point...",
	"Another thing we must discuss is...",
	"All this to say...",
	"Now, look to the person sitting next to you and think...",
	"The average person may say...",
	"On the other hand...",
	"But we can't overlook...",
	"Despite this...",
]

#var document_words
var current_sentence : String
var current_sentence_tokens : Array
var current_word : String
var current_word_idx : int = 0
var current_document : String
var current_document_tokens : Array
var current_char_idx : int = 0
var word_char_idx : int = 0

var bad_characters := "-().,'\"*_—:;"
var text_box_font
var text_box_font_size
var text_box_length
var text_box : RichTextLabel

signal incorrect_letter()
signal correct_letter()
signal completed_word(word)
signal completed_sentence()
	
var open_red
var close_red
var open_green
var close_green
var open_cursor
var close_cursor

var last_incorrect = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_red = "[color=%s]" % failure_color.to_html()
	close_red = "[/color]"
	open_green = "[color=%s]" % success_color.to_html()
	close_green = "[/color]"
	open_cursor = "[bgcolor=%s]" % cursor_color.to_html()
	close_cursor = "[/bgcolor]"
	
	#DocumentHandler.get_specific_document("tiny_test")
	DocumentHandler.get_next_document()
	load_font_data(label)
	parse_document(DocumentHandler.get_current_file())
	load_current_sentence()
	
func on_completed_sentence() -> void:
	load_current_sentence()
	
func on_correct_letter() -> void:	
	var highlighted_green = current_sentence.substr(0, current_char_idx)
	var current_character = current_sentence.substr(current_char_idx, 1)
	var non_highlighted = current_sentence.substr(current_char_idx+1)
	
	label.text = open_green + highlighted_green + close_green + open_cursor + current_character + close_cursor + non_highlighted
	AudioHandler.playSound("typing_sounds")
	
func on_incorrect_letter() -> void:
	#pause_typing(0.5)
	if current_char_idx == last_incorrect:
		return
	last_incorrect = current_char_idx
	
	var current_label_text = label.get_parsed_text()
	var no_change_begin =  open_green + current_label_text.substr(0, current_char_idx) + close_green
	var red_text = open_red + open_cursor + current_label_text[current_char_idx] + close_cursor + close_red
	var no_change_end = current_label_text.substr(current_char_idx + 1)
	
	label.text = no_change_begin + red_text + no_change_end
	
	# Animate stutter word
	AudioHandler.playSound("incorrect")
	stutter()

func on_completed_word(word) -> void:
	animalese_player.play_word(word)
	animate_word3D(current_word, fil.wordPosition.global_position)
	fil.speak_animation()
	addScore()
	#AudioHandler.playSound("typing_ding")
	
func load_font_data(label):
	text_box = label
	text_box_font = label.get_theme_default_font()
	text_box_font_size = label.get_theme_default_font_size()
	#print("FONTER ", label.theme_override_font_sizes.normal_font_size)
	text_box_length = label.size.x - 48
	
# Advance the index into the word
func advance_idx():
	# First advance the character
	if(current_sentence[current_char_idx] != " "):
		word_char_idx += 1
		AudioHandler.playSound("typing_sound")
		
	current_char_idx += 1
	emit_signal("correct_letter")
	# Then lets advance the word
	if word_char_idx == current_word.length():
		word_char_idx = 0
		current_word_idx += 1
		emit_signal("completed_word", current_word)
		#AudioHandler.playSound("test_sounds")
		if current_word_idx < len(current_sentence_tokens):
			current_word = current_sentence_tokens[current_word_idx]

	
	# If we are at the end of the sentence, get new sentence
	if current_char_idx == current_sentence.length():
		current_char_idx = 0
		
		# If we are at the end of the doc, lets get the next doc
		if len(current_document_tokens) == 0:
			var current_doc = DocumentHandler.current_document
			#if we are in a transition phrase, get a new random document
			if current_doc == "transition_phrase":
				DocumentHandler.get_next_document()
				parse_document(DocumentHandler.get_current_file())
			#if we are in a document that should transition into the next
			elif DocumentHandler.documents[current_doc]["next"] == "transition_phrase":
				DocumentHandler.toggle_document_typed(current_doc, true)
				var new_transition = TRANSITIONS.pick_random()
				parse_transition(new_transition)
			else:
				DocumentHandler.get_specific_document(DocumentHandler.documents[current_doc]['next'])
				parse_document(DocumentHandler.get_current_file())
		#otherwise, get the next sentence in current doc
		else:
			var current_text = get_line_of_text(current_document_tokens)
			current_sentence = current_text[0]
			current_sentence_tokens = current_text[1]
			current_word_idx = 0
			current_char_idx = 0
		current_word = current_sentence_tokens[0]
		#AudioHandler.playSound("test_sound")
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

func parse_transition(t):
	DocumentHandler.current_document = "transition_phrase"
	var content = t
	content = content.remove_chars(bad_characters).replace("\n", " ").to_lower()
	current_document_tokens = content.split(" ")
	#document_words = content.split(" ")
	var current_text = get_line_of_text(current_document_tokens)
	current_sentence = current_text[0]
	current_sentence_tokens = current_text[1]
	current_word = current_sentence_tokens[0]
	current_word_idx = 0
	current_char_idx = 0
	
func get_line_of_text(document_tokens):
	var first_token = document_tokens.pop_at(0)
	var text_tokens = [first_token]
	var text_to_add = first_token
	if len(document_tokens) == 0:
		return [text_to_add, text_tokens] 
	while text_box_font.get_multiline_string_size(text_to_add + " " + document_tokens[0], HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER, -1, text_box_font_size).x < text_box_length:
		var new_token = document_tokens.pop_at(0)
		text_tokens.append(new_token)
		text_to_add += " " + new_token
		if len(document_tokens) == 0:
			break
	if text_to_add[-1] != " ": text_to_add += " "
	return [text_to_add, text_tokens]

func load_current_sentence():
	label.text = open_cursor + current_sentence[0] + close_cursor + current_sentence.substr(1)
	last_incorrect = -1
	
func pause_typing(time):
	can_type = false
	await get_tree().create_timer(time).timeout
	can_type = true
	
# Handle keyboard events
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		if not can_type: return
		var typed_event = event as InputEventKey
		
		#handle shift
		if typed_event.keycode == 4194325:
			return
		
		var key_typed = PackedByteArray([typed_event.keycode]).get_string_from_utf8()
		#if key_typed == "/" and Input.is_key_pressed(KEY_SHIFT):
			#key_typed = "?"
		#if key_typed == "1" and Input.is_key_pressed(KEY_SHIFT):
			#key_typed = "!"
		#if key_typed == "8" and Input.is_key_pressed(KEY_SHIFT):
			#key_typed = "*"
		if key_typed.to_lower() != current_sentence[current_char_idx].to_lower():
			emit_signal("incorrect_letter")
		else:
			advance_idx()
			

## Instantiates word animations given the word and position you would like the animation to be played
func animate_word3D(word: String, pos: Vector3, incorrect: bool=false):
	# Create instance and set the word and position of animation
	var word_scene = word_animation_scene3D.instantiate()
	
	# Add instance to scene
	add_child(word_scene)
	word_scene.position = pos
	word_scene.look_at(camera.global_position, Vector3.UP, true)
	word_scene.set_word(word)
	if incorrect: word_scene.set_incorrect_material()

## Calls animate_word3D to produce a random stutter word
func stutter():
	animate_word3D(STUTTERS.pick_random(), fil.wordPosition.global_position, true)
