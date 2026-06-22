extends Node3D

func _ready():
	print("3D word created")
	var deathTimer = self.get_node("deathTimer")
	var rigidBody = self.get_node("RigidBody3D")
	var animation = self.get_node("textAnimation")
	
	# Connect death timer
	deathTimer.timeout.connect(queue_free)
	
	# Set random inital velocity for text rigid body
	# gravity scale = .7, linear->velocity->damp = 0
	#rigidBody.set_angular_velocity(Vector3(randf_range(-6,6),randf_range(-6,6),randf_range(-6,6)))
	#rigidBody.set_linear_velocity(Vector3(randf_range(-2,2), randf_range(1,3), randf_range(.1, .7)))
	rigidBody.set_linear_velocity(Vector3(randf_range(-2,2), randf_range(0,0), randf_range(.1, .7)))
	
	# Start animation
	animation.play("textAnimation")

# Set text of mesh
func set_word(word: String):
	var mesh = get_node("RigidBody3D/MeshInstance3D")
	mesh.mesh.text = word

func set_incorrect_material():
	var incorrect_material = load("res://Assets/Materials/3DWordIncorrect.tres")
	var mesh = get_node("RigidBody3D/MeshInstance3D")
	mesh.set_surface_override_material(0, incorrect_material)
