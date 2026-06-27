extends Minigame

func win():
	super.win()
	emit_signal("completed", "PLAYER WON FISH GAME")
	close()

var carrots_dropped = 0
@export var total_carrot_amount = 8

@onready var particles = $ScoreParticles
@onready var timer = $Timer

func _ready() -> void:
	carrots_dropped = 0
	
func _process(_delta: float) -> void:
	super._process(_delta)
	if carrots_dropped == total_carrot_amount:
		if timer.is_stopped(): timer.start(1)
		particles.emitting = true

func on_drop_area_entered(body: Node3D) -> void:
	carrots_dropped += 1
	AudioHandler.playSound("EatCarrot")
	body.queue_free()

func on_timer_timeout() -> void:
	win()
