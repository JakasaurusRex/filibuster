extends Node

@onready var documents := {
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
	"tiny_test":  {
		"file": "tiny_test.txt",
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
	if not current_document:
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
