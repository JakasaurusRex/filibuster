extends Camera3D

@export var camera_positions = [Vector3(0, 1.785, -4.76)]
@export var camera_rotations = [Vector3(-27.8, -180, 0)]

const SCRATCH_TIME = 2.0
const RAY_LENGTH := 1000

@onready var glove = $"../Glove"
@onready var capy = $"../Capy"

var looking_at_capy = false

var current_scratch_time = 0
var current_camera_index = 0

func ray_cast():
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = project_ray_origin(mouse_pos)
	var end = origin + project_ray_normal(mouse_pos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	return result

func _ready() -> void:
	looking_at_capy = false
	current_camera_index = 0
	position = camera_positions[current_camera_index]
	rotation = camera_rotations[current_camera_index]

func _process(delta: float) -> void:
	if glove.grabbing and looking_at_capy:
		current_scratch_time += delta
	
	if current_scratch_time > SCRATCH_TIME:
		current_camera_index += 1
		current_scratch_time = 0
		
		if current_camera_index == len(camera_rotations):
			current_camera_index = 0
		
		position = camera_positions[current_camera_index]
		rotation = camera_rotations[current_camera_index]
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var ray_cast_result = ray_cast()
		if !ray_cast_result:
			return
		var result_position = ray_cast_result.get("position")
		var result_object  = ray_cast_result.get("collider")

		var mouse_pos = get_viewport().get_mouse_position()
		var origin = project_ray_origin(mouse_pos)
		var end = project_ray_normal(mouse_pos)
		var depth = origin.distance_to(result_position)
		var final_position = origin + end * depth
		glove.global_position = final_position
		glove.look_at(result_object.global_position)
		
		if(result_object == capy):
			looking_at_capy = true
		else:
			looking_at_capy = false
