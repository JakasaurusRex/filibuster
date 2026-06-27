extends Minigame


@onready var bomb = $Bomb
@onready var camera = $Camera3D

func _ready() -> void:
	pass
	
func win():
	super.win()
	emit_signal("completed", "PLAYER WON BOMB GAME")
	close()

func lose():
	super.lose()
	emit_signal("failed", "PLAYER LOST BOMB GAME")
	close()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		var ray_cast_result = camera.ray_cast()
		if !ray_cast_result:
			return
			
		bomb.on_click(ray_cast_result)


func on_bomb_completed() -> void:
	win()

func on_bomb_exploded() -> void:
	lose()
