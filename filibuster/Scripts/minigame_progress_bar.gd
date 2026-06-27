extends Control

@onready var spacer := $progressVbox/spacer
@onready var thumb := $progressVbox/thumb

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
	
