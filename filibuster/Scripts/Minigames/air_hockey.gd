extends Minigame

@onready var playerPaddle = $playerPaddle
@onready var playerPaddle2 = $playerPaddle2
@onready var puck = $puck
@onready var camera = $Camera3D


func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	var space_state = camera.get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * 500
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = 111101
	
	var result = space_state.intersect_ray(query)
	var pos
	
	if "position" in result:
		pos = result["position"]
		playerPaddle.position = pos
		#print(pos)
		#print(result["collider"].name)
	#print(puck.position)
	

func win():
	super.win()
	emit_signal("completed", "PLAYER WON AIR HOCKEY")
	close()

func lose():
	super.lose()
	emit_signal("finished", "PLAYER LOST AIR HOCKEY")
	close()
