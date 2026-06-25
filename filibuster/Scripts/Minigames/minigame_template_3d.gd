extends Minigame

@onready var phone = $Phone
@onready var camera = $Camera3D

func _ready() -> void:
	pass
	
func win():
	super.win()
	emit_signal("completed", "PLAYER WON TEMPLATE GAME")
	close()

func lose():
	super.lose()
	emit_signal("finished", "PLAYER LOST TEST GAME")
	close()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		var ray_cast_result = camera.ray_cast()
		if !ray_cast_result:
			return
			
		print(ray_cast_result)
			
		var result_position = ray_cast_result.get("position")
		var result_object = ray_cast_result.get("collider").get_parent()
		print(result_object)
		
		phone.on_click(result_object)
