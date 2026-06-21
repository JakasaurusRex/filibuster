extends RigidBody2D

func _ready():
	print('here')
	self.set_angular_velocity(randf_range(-8,8))
	self.set_linear_velocity(Vector2(randf_range(-200,200), randf_range(-150,-400)))
