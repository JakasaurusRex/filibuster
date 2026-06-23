extends Node3D

@export var skeleton : Skeleton3D
@export var bone_to_follow : String
@onready var base_bone_rotation = Vector3.ZERO
@onready var base_rotation = rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bone_id = skeleton.find_bone(bone_to_follow)
	base_bone_rotation = skeleton.get_bone_pose_rotation(bone_id).get_euler()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bone_id = skeleton.find_bone(bone_to_follow)
	var bone_rotation = skeleton.get_bone_pose_rotation(bone_id).get_euler()
	rotation = base_rotation + (bone_rotation - base_bone_rotation)/100
	
