extends Minigame

var state_incorrect_material = load("res://Assets/Materials/StateIncorrect.tres")
var state_correct_material = load("res://Assets/Materials/StateCorrect.tres")
var state_normal_material = load("res://Assets/Materials/StateNormal.tres")
var state_hover_material = load("res://Assets/Materials/StateHover.tres")
const states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

@onready var timer = $Timer
@onready var camera = $Camera3D
@export var FLASH_TIMER = 0.2
var flashing_gameover = false
@export var MAX_FLASHES = 3
var flash_counter = 0
var selected_mesh : MeshInstance3D = null
var flash_material
var did_win = false


@onready var state_text = $StateTextBox/StateText
@onready var text_box = $StateTextBox/TextBox
var picked_state

var current_hover_mesh : MeshInstance3D = null

func _ready() -> void:
	picked_state = states.pick_random()
	state_text.mesh.text = picked_state
	
	var text_width = state_text.get_aabb().size.x
	text_box.size.x = text_width * 1.2
	
func win():
	super.win()
	emit_signal("completed", "PLAYER WON TEMPLATE GAME")
	close()

func lose():
	super.lose()
	emit_signal("finished", "PLAYER LOST TEST GAME")
	close()
		

func on_timer_timeout() -> void:
	if selected_mesh.get_surface_override_material(0) == flash_material:
		selected_mesh.set_surface_override_material(0, state_normal_material)
		flash_counter += 1
	else:
		selected_mesh.set_surface_override_material(0, flash_material)
		
	if flash_counter == 3:
		if did_win: win()
		else: lose()
	
	timer.start(FLASH_TIMER)

	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		var ray_cast_result = camera.ray_cast()
		if !ray_cast_result or flashing_gameover:
			return
			
		var result_position = ray_cast_result.get("position")
		var result_mesh = ray_cast_result.get("collider").get_parent()
		var result_object  = result_mesh.get_parent()
		
		selected_mesh = result_mesh
		
		did_win = result_object.name == picked_state
		flashing_gameover = true
		
		if did_win: flash_material = state_correct_material
		else: flash_material = state_incorrect_material
	
		timer.start(FLASH_TIMER)
	
	if event is InputEventMouseMotion:
		var ray_cast_result = camera.ray_cast()
		if !ray_cast_result or flashing_gameover:
			if current_hover_mesh:
				current_hover_mesh.set_surface_override_material(0, state_normal_material)
				current_hover_mesh = null
			return
			
		var result_position = ray_cast_result.get("position")
		var result_object  = ray_cast_result.get("collider").get_parent()
		
		if current_hover_mesh and current_hover_mesh != result_object:
			current_hover_mesh.set_surface_override_material(0, state_normal_material)
		
		current_hover_mesh = result_object
		current_hover_mesh.set_surface_override_material(0, state_hover_material)
		
		
