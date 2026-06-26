extends Minigame

func win():
	super.win()
	emit_signal("completed", "PLAYER WON FISH GAME")
	close()

var carrots_dropped = 0
@export var total_carrot_amount = 8

func _ready() -> void:
	carrots_dropped = 0
	
func _process(_delta: float) -> void:
	if carrots_dropped == total_carrot_amount:
		win()

func on_drop_area_entered(body: Node3D) -> void:
	carrots_dropped += 1
	body.queue_free()
