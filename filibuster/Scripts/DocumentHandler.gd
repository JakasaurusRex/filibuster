extends Node

@onready var documents := {
	"genesis": {
		"file": "genesis.txt",
		"next": null,
		"typed": false,
	},
	"bee": {
		"file": "bee.txt",
		"next": null,
		"typed": false
	},
	"game_jam_text": {
		"file": "jam_info.txt",
		"next": null,
		"typed": false
	},
	"tiny_test":  {
		"file": "tiny_test.txt",
		"next": null,
		"typed": false
	},
	"vampire":  {
		"file": "vampire.txt",
		"next": null,
		"typed": false
	},
	"anything_else":  {
		"file": "anything_else.txt",
		"next": null,
		"typed": false
	},
	"platypus_control":  {
		"file": "platypus_control.txt",
		"next": null,
		"typed": false
	},
	"batman_begin":  {
		"file": "batman_begin.txt",
		"next": null,
		"typed": false
	}
	
}

var current_document : String

func get_random_document():
	var random_document = documents.keys().pick_random()
	while documents[random_document]["typed"]:
		random_document = documents.keys().pick_random()
	return random_document
	
func get_next_document():
	if not current_document:
		current_document = get_random_document()
	else:
		documents[current_document]["typed"] = true
		if documents[current_document]["next"]:
			current_document = documents[current_document]["next"]
		else:
			current_document = get_random_document()
	return current_document

func get_specific_document(doc):
	current_document = doc
	
func get_current_file():
	return documents[current_document]['file']
