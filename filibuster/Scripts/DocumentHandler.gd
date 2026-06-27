extends Node

@onready var documents := {
	#"tiny_test":  {
		#"file": "tiny_test.txt",
		#"next": "transition_phrase",
		#"typed": false
	#},
	"intro_speech": {
		"file": "intro_speech.txt",
		"next": "intro_speech_finished",
		"typed": false,
	},
	"genesis": {
		"file": "genesis.txt",
		"next": "transition_phrase",
		"typed": false,
	},
	"bee": {
		"file": "bee.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"game_jam_text": {
		"file": "jam_info.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"vampire":  {
		"file": "vampire.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"anything_else":  {
		"file": "anything_else.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"platypus_control":  {
		"file": "platypus_control.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"batman_begin":  {
		"file": "batman_begin.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"gettysburg":  {
		"file": "gettysburg.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"hate": {
		"file": "hate.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"coconut_tree": {
		"file": "coconut_tree.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"avatar": {
		"file": "avatar.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"fish": {
		"file": "one_fish_two_fish.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"syrup": {
		"file": "syrup.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"had_a_dream": {
		"file": "had_a_dream.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"tangled": {
		"file": "tangled.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"six_seven": {
		"file": "six_seven.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"birthday_gift": {
		"file": "birthday_gift.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"tuesday": {
		"file": "tuesday.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"with_the_fur": {
		"file": "with_the_fur.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"abandon_hope": {
		"file": "abandon_hope.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"leonardo_medusa": {
		"file": "leonardo_medusa.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"zoe_wins": {
		"file": "zoe_wins.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"books": {
		"file": "books.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"absence_of_space": {
		"file": "absence_of_space.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"hog_rider": {
		"file": "hog_rider.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"mars_cabal": {
		"file": "mars_cabal.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"juice": {
		"file": "juice.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"one_ring": {
		"file": "one_ring.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"spider_pig": {
		"file": "spider_pig.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"mlp": {
		"file": "mlp.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"are_you_with_us": {
		"file": "are_you_with_us.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"sue_kitty": {
		"file": "sue_kitty.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"pathetic_card": {
		"file": "pathetic_card.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"pot_of_greed": {
		"file": "pot_of_greed.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"bakugan": {
		"file": "bakugan.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"precise_gunplay": {
		"file": "precise_gunplay.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"scatman": {
		"file": "scatman.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"fifteen_minute_delay": {
		"file": "fifteen_minute_delay.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"jam_a_man": {
		"file": "jam_a_man.txt",
		"next": "transition_phrase",
		"typed": false
	},
	"dog_cam": {
		"file": "jam_a_man.txt",
		"next": "transition_phrase",
		"typed": false
	},
}

var current_document : String

func get_random_document():
	var random_document
	var document_list = documents.keys()
	var unread_documents = document_list.filter(func (doc): return not documents[doc]["typed"])
	if len(unread_documents) == 0:
		document_list.map(func (doc): documents[doc]["typed"] = false)
		random_document = document_list.pick_random()
	else:
		random_document = unread_documents.pick_random()
	return random_document
	
func get_next_document():
	if not current_document or current_document == "":
		current_document = get_random_document()
	else:
		if current_document == "transition_phrase":
			current_document = get_random_document()
			return current_document
		toggle_document_typed(current_document, true)
		if documents[current_document]["next"]:
			current_document = documents[current_document]["next"]
		else:
			current_document = get_random_document()
	return current_document

func toggle_document_typed(doc, on):
	documents[doc]['typed'] = on
	
func get_specific_document(doc):
	current_document = doc
	
func get_current_file():
	return documents[current_document]['file']

func delete_intro_document():
	documents.erase("intro_speech")
	current_document = ""
	
func reset():
	documents.get_or_add("intro_speech", {
		"file": "intro_speech.txt",
		"next": "intro_speech_finished",
		"typed": false,
	})
	
	current_document = "intro_speech"
	for document in documents.keys():
		documents[document] = false
	
