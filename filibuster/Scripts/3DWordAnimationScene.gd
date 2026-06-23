extends Node3D

@onready var deathTimer := $deathTimer
@onready var rigidBody := $RigidBody3D
@onready var mesh := $RigidBody3D/MeshInstance3D
@onready var animation := $textAnimation

func _ready():
	# Connect death timer
	deathTimer.timeout.connect(queue_free)
	
	# Set random inital velocity for text rigid body
	# gravity scale = .7, linear->velocity->damp = 0
	#rigidBody.set_angular_velocity(Vector3(randf_range(-6,6),randf_range(-6,6),randf_range(-6,6)))
	#rigidBody.set_linear_velocity(Vector3(randf_range(-2,2), randf_range(1,3), randf_range(.1, .7)))
	var body_velocity = Vector3(randf_range(0.5,2), randf_range(0,0), randf_range(.1, .7))
	if randf() < 0.5:
		body_velocity.x *= -1
	rigidBody.set_linear_velocity(Vector3(randf_range(-2,2), randf_range(0,0), randf_range(.1, .7)))
	
	# Start animation
	animation.play("textAnimation")

# Set text of mesh
func set_word(word: String):
	mesh.mesh.text = word

func set_incorrect_material():
	var incorrect_material = load("res://Assets/Materials/3DWordIncorrect.tres")
	mesh.set_surface_override_material(0, incorrect_material)
