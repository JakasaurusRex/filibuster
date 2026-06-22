extends CharacterBody3D

const SPEED = 5.0

@export var water_mesh : MeshInstance3D
@export var speed := 3.0

var target_position: Vector3
var target_reached_distance := 0.3

func _get_target_position():
	var half_size = water_mesh.mesh.size / 2
	
	return Vector3(
		randf_range(water_mesh.global_position.x - half_size.x, water_mesh.global_position.x + half_size.x),
				randf_range(water_mesh.global_position.y - half_size.y, water_mesh.global_position.y + half_size.y),
						randf_range(water_mesh.global_position.z - half_size.z, water_mesh.global_position.z + half_size.z)
	)

func _physics_process(_delta: float) -> void:
	if global_position.distance_to(target_position) < target_reached_distance:
		target_position = _get_target_position()
	
	var direction = global_position.direction_to(target_position)
	velocity = direction * speed
	
	look_at(global_position + direction, Vector3.UP, true)
	
	move_and_slide()
