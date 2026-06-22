extends Camera3D

const RAY_LENGTH := 1000

var held_object
var held_object_depth

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if held_object:
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = project_ray_origin(mouse_pos)
		var end = project_ray_normal(mouse_pos)
		var final_position = origin + end * held_object_depth
		held_object.global_position = final_position

func ray_cast():
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = project_ray_origin(mouse_pos)
	var end = origin + project_ray_normal(mouse_pos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	result = result.get("collider")
	return result
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		var ray_cast_result = ray_cast()
		if !ray_cast_result or ray_cast_result is StaticBody3D:
			return

		var mouse_pos = get_viewport().get_mouse_position()
		var origin = project_ray_origin(mouse_pos)
		held_object_depth = origin.distance_to(ray_cast_result.global_position)
		
		held_object = ray_cast_result
	elif Input.is_action_just_released("left_mouse"):
		if held_object:
			held_object.linear_velocity = Vector3.ZERO
			held_object = null
			held_object_depth = null
		
		
		
