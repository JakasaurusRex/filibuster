extends Minigame

@onready var playerPaddle = $playerPaddle
@onready var playerPaddle2 = $playerPaddle2
@onready var puck = $puck
@onready var camera = $Camera3D
@onready var move_speed = 5
@onready var score_particles = $ScoreParticles

func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	super._process(delta)
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
		playerPaddle.position = playerPaddle.position.move_toward(pos, move_speed*delta)
	

func win():
	super.win()
	emit_signal("completed", "PLAYER WON AIR HOCKEY")

func lose():
	super.lose()
	emit_signal("finished", "PLAYER LOST AIR HOCKEY")

func _on_win_area_body_entered(body: Node3D) -> void:
	if body == puck:
		AudioHandler.playSound("Correct")
		win()
		score_particles.emitting = true
		get_tree().create_timer(1).timeout.connect(close)
	

func _on_lose_area_body_entered(body: Node3D) -> void:
	if body == puck:
		lose()
		get_tree().create_timer(1).timeout.connect(close)
