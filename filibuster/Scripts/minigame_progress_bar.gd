extends Control

@onready var spacer := $progressVbox/spacer
@onready var spacerBottom := $progressVbox/spacerBottom
@onready var thumb := $progressVbox/thumb
@onready var hand := $progressVbox/hand
@onready var tip := $progressVbox/tip

var thumb_val := 1.0
var spacer_val := 0.0

func _process(delta: float) -> void:
	thumb.size_flags_stretch_ratio = move_toward(thumb.size_flags_stretch_ratio, thumb_val, delta)
	spacer.size_flags_stretch_ratio = move_toward(spacer.size_flags_stretch_ratio, spacer_val, delta)
	
func update_progress(prog):
	thumb_val = 1.0-prog
	spacer_val = prog
	#thumb.size_flags_stretch_ratio = 1.0-prog
	#spacer.size_flags_stretch_ratio = prog
	
func thumbs_down():
	tip.visible = false
	thumb.visible = false
	spacerBottom.visible = false
	hand.texture = load("res://Assets/Graphics/Thumb/thumbs_down.png")

func reset():
	tip.visible = true
	thumb.visible = true
	spacerBottom.visible = true
	hand.texture = load("res://Assets/Graphics/Thumb/hand.png")
	thumb_val = 1.0
	spacer_val = 0.0
