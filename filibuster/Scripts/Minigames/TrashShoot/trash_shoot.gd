extends "res://Scripts/Minigames/minigame_template_2d.gd"

var mouse_pos = Vector2(0,0)
var start_pos = Vector2(0,0)
var end_pos = Vector2(0,0)
@onready var ball_scene = preload("res://Assets/Scenes/Minigames/TrashShoot/ball.tscn")
@onready var score_particles = $CanvasLayer/ScoreParticles
@onready var arrow = $CanvasLayer/Arrow
@export_range(0,20) var fling_strength: float = 15
@export_range(0,90) var launch_angle: float = 45
@onready var launch_vector = Vector2.RIGHT.rotated(deg_to_rad(launch_angle))
var dragging = false
var ball

func _ready() -> void:
	_reset_ball()

func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion:
		if dragging:
			arrow.points = [start_pos, mouse_pos]
		mouse_pos = event.position
	if event is InputEventMouseButton:
		# Left click
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = true
			start_pos = mouse_pos
			arrow.points = [start_pos]
		# Release left click
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = false
			arrow.points = []
			end_pos = mouse_pos
			fling_ball()

func _reset_ball():
	var new_ball = ball_scene.instantiate()
	new_ball.position = Vector3(0, 1.842, 2.382)
	add_child(new_ball)
	ball = new_ball

## Applys impulse to ball using start_pos and end_pos variables to calculate magnitude and direction
func fling_ball():
	print("FLING")
	var difference = start_pos - end_pos
	var direction = difference.normalized()
	var magnitude = (difference*Vector2(0,7)).length() / minigame_size.x / 10
	var impulse = Vector3(direction.x, launch_vector[0], -launch_vector[1]) * magnitude * fling_strength
	ball.freeze = false
	ball.apply_impulse(impulse, Vector3.ZERO)


func _on_score_detector_body_entered(body: Node3D) -> void:
	print(body)
	print("Successful trash shoot")
	score_particles.emitting = true
	win()
	get_tree().create_timer(2).timeout.connect(close)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == ball:
		_reset_ball()
