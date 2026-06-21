extends Node3D


func _ready():
	var deathTimer = self.get_node("deathTimer")
	var rigidBody = self.get_node("RigidBody3D")
	
	# Connect death timer
	deathTimer.timeout.connect(queue_free)
	
	# Set random inital velocity for text rigid body
	rigidBody.set_angular_velocity(Vector3(randf_range(-6,6),randf_range(-6,6),randf_range(-6,6)))
	rigidBody.set_linear_velocity(Vector3(randf_range(-3,3), randf_range(2,4), randf_range(1,2.5)))

# Set text of mesh
func set_word(word: String):
	var mesh = self.get_node("RigidBody3D/MeshInstance3D")
	mesh.mesh.text = word
