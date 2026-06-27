extends Minigame

func win():
	super.win()
	emit_signal("completed", "PLAYER WON DOG PETTING GAME")
	close()

func lose():
	super.lose()
	emit_signal("failed", "PLAYER LOST DOG PETTING GAME")
	close()

@export var camera_positions = [Vector3(0, 1.785, -4.76)]
@export var camera_rotations = [Vector3(-27.8, -180, 0)]

const SCRATCH_TIME = 1.0

@onready var camera = $Camera3D
@onready var glove = $Glove
@onready var capy = $Capy
@onready var word_spawn_position = $WordSpawnPosition

var looking_at_capy = false

var current_scratch_time = 0
var current_camera_index = 0
var current_mouse_delta = Vector2.ZERO

var word_animation_scene3D = preload("res://Assets/Scenes/3DWordAnimation.tscn")

const noises := [
	"meow",
	"prrr",
	"noms",
	"uwu",
	"owo",
	"nyannnn",
	"<3"
]

func make_noise():
	# Create instance and set the word and position of animation
	var word_scene = word_animation_scene3D.instantiate()
	# Add instance to scene
	add_child(word_scene)
	word_scene.set_incorrect_material()
	

	word_scene.position = word_spawn_position.position
	word_scene.look_at(camera.global_position, Vector3.UP, true)
	word_scene.set_word(noises.pick_random())

func _ready() -> void:
	looking_at_capy = false
	current_camera_index = 0
	camera.position = camera_positions[current_camera_index]
	camera.rotation = camera_rotations[current_camera_index]

func _process(delta: float) -> void:
	super._process(delta)
	if glove.grabbing and looking_at_capy and current_mouse_delta:
		current_scratch_time += delta
		current_mouse_delta = null
		
		var rounded = snapped(current_scratch_time, 0.01)
		
		if fmod(rounded, 0.75) == 0:
			AudioHandler.playSound("Scratching")
			make_noise()
	
	if current_scratch_time > SCRATCH_TIME:
		current_camera_index += 1
		current_scratch_time = 0
		
		AudioHandler.playSound("meow")
		
		if current_camera_index == len(camera_rotations):
			current_camera_index = 0
			win()
		
		camera.position = camera_positions[current_camera_index]
		camera.rotation = camera_rotations[current_camera_index]
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var ray_cast_result = camera.ray_cast()
		if !ray_cast_result or ray_cast_result is RigidBody3D:
			return
			
		var result_position = ray_cast_result.get("position")
		var result_object  = ray_cast_result.get("collider")

		var mouse_pos = get_viewport().get_mouse_position()
		var origin = camera.project_ray_origin(mouse_pos)
		var end = camera.project_ray_normal(mouse_pos)
		var depth = origin.distance_to(result_position)
		var final_position = origin + end * depth
		glove.global_position = final_position
		glove.look_at(result_object.global_position)
		
		if(result_object == capy):
			looking_at_capy = true
			current_mouse_delta = event.relative
		else:
			looking_at_capy = false
