extends Node

enum GameState {
	NOT_STARTED,
	PLAYING,
	GAME_OVERING,
	GAME_OVER,
}

@onready var minigame_anim := $minigameAnim
@onready var minigame_slots := {
	"slot_1": $"../MinigameUI/MinigameCont/slot1/minigameSlot1",
	"slot_2": $"../MinigameUI/MinigameCont/slot2/minigameSlot2",
	"slot_3": $"../MinigameUI/MinigameCont/slot3/minigameSlot3",
	"slot_4": $"../MinigameUI/MinigameCont/slot4/minigameSlot4",
}
@onready var minigames := {
	"slot_1": null,
	"slot_2": null,
	"slot_3": null,
	"slot_4": null,
}
@onready var camera := $"../Camera3D"
@onready var camera_views := {}
@onready var camera_angles := $"../CameraAngles"
var minigame_timer_range_min = 2.5
var minigame_timer_range_max = 5.0
var rolling_out_mini_game = false
var roll_out_speed = 0.5
var rolling_off_mini_game = false
const fish_minigame = preload("res://Assets/Scenes/Minigames/FishMinigame/FishMinigame.tscn")

@onready var game_over_timer = $GameOverTimer
@onready var minigame_timer := $MinigameTimer
@onready var camera_timer := $CameraTimer
@export var game_over_time = 1

var current_state = GameState.PLAYING
var current_camera_view = "defaultView"

func _ready() -> void:
	minigame_timer.timeout.connect(time_for_minigame)
	camera_timer.timeout.connect(transition_camera)
	
	minigame_timer.start(randf_range(minigame_timer_range_min, minigame_timer_range_max))
	camera_timer.start(5)
	load_camera_views()
	current_state = GameState.PLAYING

func _process(delta: float) -> void:
	if current_state == GameState.GAME_OVER:
		get_tree().quit()
	
func on_dial_empty() -> void:
	current_state = GameState.GAME_OVERING
	game_over_timer.start(game_over_time)

func on_timer_timeout() -> void:
	current_state = GameState.GAME_OVER

func time_for_minigame():
	print("MINIGAME TIMER TIMED OUT")
	spawn_minigame()
	minigame_timer.start(randf_range(minigame_timer_range_min, minigame_timer_range_max))
	
func spawn_minigame() -> void:
	var open_slots = minigames.keys().filter(func(slot): return minigames[slot] == null)
	if len(open_slots) == 0: return
	var new_minigame_viewport = SubViewport.new()
	new_minigame_viewport.own_world_3d = true
	new_minigame_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	var minigame_slot = open_slots.pick_random()
	
	var random_minigame = MinigameHandler.get_random_minigame()
	var new_minigame = MinigameHandler.get_minigame_scene(random_minigame).instantiate()
	
	minigame_slots[minigame_slot].add_child(new_minigame_viewport)
	new_minigame_viewport.add_child(new_minigame)
	minigames[minigame_slot] = new_minigame_viewport
	
	new_minigame_viewport.size = new_minigame.minigame_size
	new_minigame.start()
	new_minigame.completed.connect(minigame_completed)
	new_minigame.failed.connect(minigame_failed)
	new_minigame.closed.connect(minigame_closed.bind(minigame_slot))

func minigame_completed(completion_event):
	print("COMPLETED MINIGAME WITH EVENT: %s" % completion_event)
	
func minigame_failed(failure_event):
	print("FAILED MINIGAME WITH EVENT: %s" % failure_event)
	
func minigame_closed(slot):
	print("MINIGAME IN SLOT %s CLOSED" % slot)
	minigames[slot].queue_free() 
	minigames[slot] = null

func load_camera_views():
	for view in camera_angles.get_children():
		camera_views[view.name] = view

func get_random_camera_view():
	var new_view = camera_views.keys().pick_random()
	while new_view == current_camera_view:
		new_view = camera_views.keys().pick_random()
	return new_view
	
func transition_camera(duration:=2.0, view:=""):
	if view == "": view = get_random_camera_view()
	current_camera_view = view
	var camera_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	var end_transform = camera_views[view].global_transform
	var end_fov = camera_views[view].fov
	camera_tween.tween_property(camera, "global_transform", end_transform, duration)
	camera_tween.tween_property(camera, "fov", end_fov, duration)
