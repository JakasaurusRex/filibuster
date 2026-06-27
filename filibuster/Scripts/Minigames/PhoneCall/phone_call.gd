extends Minigame

@onready var phone = $Phone
@onready var camera = $Camera3D
@onready var timer = $Timer
	
func win():
	super.win()
	emit_signal("completed", "PLAYER WON PHONE GAME")
	close()

func lose():
	super.lose()
	emit_signal("failed", "PLAYER LOST PHONE GAME")
	close()
	
var did_win = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		var ray_cast_result = camera.ray_cast()
		if !ray_cast_result:
			return
			
		var result_position = ray_cast_result.get("position")
		var result_object = ray_cast_result.get("collider").get_parent()
		
		phone.on_click(result_object)


func on_phone_call_failed() -> void:
	AudioHandler.playSound("waranty")
	timer.start(3)


func on_phone_call_successful() -> void:
	AudioHandler.playSound("tony")
	timer.start(2)
	did_win = true


func on_timer_timeout() -> void:
	if did_win: win()
	else: lose()
