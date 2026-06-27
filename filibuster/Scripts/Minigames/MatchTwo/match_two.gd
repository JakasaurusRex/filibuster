extends "res://Scripts/Minigames/minigame_template_2d.gd"
@onready var available_cards = [
	'1','1','2','2','3','3','4','4','5','5','6','6','7','7','8','8'
]
var cards: Array[Array]
var card_scene = preload("res://Assets/Scenes/MatchTwo/Card.tscn")
const TILE_SIZE = 1
var card_hovering = null
var card_selected = null
@onready var matches = 0

func _ready() -> void:
	var new_card: Node3D
	# Place cards on screen randomly
	for r in 4:
		for c in 4:
			new_card = card_scene.instantiate()
			add_child(new_card)
			
			var i = randi() % available_cards.size()
			new_card.set_number(available_cards.pop_at(i))
			new_card.connect('hover_card', _on_card_hover)
			new_card.position = Vector3(r*TILE_SIZE+.5, .2, c*TILE_SIZE+.5)

func _input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		# Left click
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# CLICK ON CARD
			if card_selected == card_hovering or card_hovering.is_matched: return
			card_hovering.flip_up()
			# CHECK IF A CARD IS ALREADY SELECTED
			if not card_selected:
				card_selected = card_hovering
			# CHECK IF BOTH CARDS MATCH
			else:
				# CARDS MATCH
				if card_selected.number == card_hovering.number:
					card_selected.set_matched()
					card_hovering.set_matched()
					matches += 1
					# WIN
					if matches >= 8:
						win()
						get_tree().create_timer(2).timeout.connect(close)
				else:
					card_selected.flip_down()
					card_hovering.flip_down()
				card_selected = null

func _on_card_hover(card_num):
	card_hovering = card_num
