extends Node3D
var selected = false
var is_matched = false
@onready var card_mesh = $CardMesh
@onready var number_label = $CardMesh/Number
@onready var number = -1
@onready var anim = $AnimationPlayer
signal hover_card(number)

func set_number(num: String):
	number = num
	number_label.text = num

func set_selected(val: bool):
	selected = val

func flip_up():
	#play flip up animation
	anim.play("faceup")

func flip_down():
	#play flip down animation
	anim.play("facedown")

func set_matched():
	# Play animation with visibility
	is_matched = true
	anim.play('match')
	await anim.animation_finished
	visible = false

func _on_area_3d_mouse_entered() -> void:
	emit_signal('hover_card', self)
