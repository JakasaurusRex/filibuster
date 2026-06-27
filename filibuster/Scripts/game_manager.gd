extends Node

enum GameState {
	NOT_STARTED,
	INTRO,
	PLAYING,
	GAME_OVERING,
	GAME_OVER,
}

@onready var typing_ui := $"../TypingUI"
@onready var minigame_anim := $minigameAnim
@onready var minigame_slots := {
	"slot_1": $"../MinigameUI/MinigameCont/slot1/minigameSlot1",
	"slot_2": $"../MinigameUI/MinigameCont/slot2/minigameSlot2",
}
@onready var minigames := {
	"slot_1": null,
	"slot_2": null,
}
@onready var tvs := {
	"slot_1": $"../minigame1TVs".get_children(),
	"slot_2": $"../minigame2TVs".get_children(),
}

@onready var camera := $"../Camera3D"
@onready var camera_views := {}
@onready var camera_angles := $"../CameraAngles"

@onready var skipLabel := $"../skipLabel"

var minigame_timer_range_min = 15.0
var minigame_timer_range_max = 30.0

@onready var game_over_timer = $GameOverTimer
@onready var minigame_timer := $MinigameTimer
@onready var camera_timer := $CameraTimer

#on god idk what this is
@export var game_over_time = 1

@export var MAX_RATING := 60
@export var STARTING_RATING := 50
@export var RATING_LOSS_PER_SEC := 1
@export var RATING_ON_WORD := 1
@export var RATING_ON_TYPO := 1
@export var RATING_ON_MINIGAME_WIN := 1
@export var RATING_ON_MINIGAME_LOSS := 1
@onready var rating_timer = $RatingTimer
var current_rating : int

const MINUTES_TO_24_HOURS := 3
var start_time := 0.0 #TIME WE STARTED GAME AT
var elapsed_time := 0.0 #TIME SINCE STARTING GAME IN SECONDS
var time_ratio := 0.0 #RATIO OF REAL TIME TO IN GAME TIME
@onready var digital_clock := $"../DigitalClock"
@onready var analog_clock := $"../AnalogClock"

var word_animation_scene2D = preload("res://Assets/Scenes/2DWordAnimation.tscn")

var current_state = GameState.NOT_STARTED
var current_camera_view = "defaultView"

var minigame_border := Vector2(16,16)

@export var DO_INTRO := true


func _ready() -> void:
	minigame_timer.timeout.connect(time_for_minigame)
	camera_timer.timeout.connect(transition_camera)
	typing_ui.intro_speech_finished.connect(intro_speech_finished)
	time_ratio = (MINUTES_TO_24_HOURS * 60.0) / 86400
	
	load_camera_views()
	
	if DO_INTRO:
		start_intro()
	else:
		start_game()
	

func _process(delta: float) -> void:
	if current_state == GameState.PLAYING:
		#lose game to approval rating
		#if current_rating <= 0: lose_game()
		
		#win game by lasting 24 hours
		if elapsed_time >= MINUTES_TO_24_HOURS * 60: win_game()

func _physics_process(_delta: float) -> void:
	if current_state == GameState.PLAYING:
		get_current_time()
		var elapsed_hours = elapsed_time_to_hours()
		var elapsed_minutes = elapsed_hours - int(elapsed_hours)
		digital_clock.parse_time(int(elapsed_hours), int(elapsed_minutes*60))
		analog_clock.parse_time(int(elapsed_hours), int(elapsed_minutes*60), _delta)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape") and current_state == GameState.INTRO:
		start_game()
	
func start_intro():
	current_state = GameState.INTRO
	current_rating = STARTING_RATING
	camera.global_transform = camera_views["courtBackView"].global_transform
	camera.fov = camera_views["courtBackView"].fov
	
	DocumentHandler.get_specific_document("intro_speech")
	typing_ui.load_font_data(typing_ui.label)
	typing_ui.parse_document(DocumentHandler.get_current_file())
	typing_ui.load_current_sentence()
	typing_ui.toggleTyping(true)

func intro_speech_finished():
	start_game()

func skip_intro():
	start_game()
	
func start_game():
	current_state = GameState.PLAYING
	current_rating = STARTING_RATING
	
	start_time = Time.get_ticks_msec()
	
	rating_timer.start(1.0)
	minigame_timer.start(randf_range(minigame_timer_range_min, minigame_timer_range_max))
	camera_timer.start(20.0)
	transition_camera(2.0, "defaultView")
	
	DocumentHandler.delete_intro_document()
	DocumentHandler.get_next_document()
	typing_ui.load_font_data(typing_ui.label)
	typing_ui.parse_document(DocumentHandler.get_current_file())
	typing_ui.load_current_sentence()
	typing_ui.toggleTyping(true)
	
	skipLabel.visible = false
	
func win_game():
	print("GAME WON, 24 HOURS BUSTED")
	current_state = GameState.GAME_OVER
	$"../winLabel".visible = true
	get_tree().paused = true
	
func lose_game():
	print("GAME LOST, NO APPROVAL")
	current_state = GameState.GAME_OVER
	$"../loseLabel".visible = true
	get_tree().paused = true
	
func get_current_time():
	elapsed_time = (Time.get_ticks_msec() - start_time)/1000

func elapsed_time_to_hours():
	var elapsed_hours = elapsed_time / time_ratio / 3600
	return elapsed_hours

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
	new_minigame_viewport.physics_object_picking = true
	#new_minigame_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	#new_minigame_viewport.msaa_2d = Viewport.MSAA_8X
	#new_minigame_viewport.msaa_3d = Viewport.MSAA_8X
	var minigame_slot = open_slots.pick_random()
	
	var random_minigame = MinigameHandler.get_random_minigame()
	var new_minigame = MinigameHandler.get_minigame_scene(random_minigame).instantiate()
	
	minigame_slots[minigame_slot].add_child(new_minigame_viewport)
	new_minigame_viewport.add_child(new_minigame)
	minigames[minigame_slot] = new_minigame_viewport
	
	
	new_minigame_viewport.size = new_minigame.minigame_size
	minigame_slots[minigame_slot].get_parent().find_child("gameBorder").visible = true
	minigame_slots[minigame_slot].get_parent().find_child("gameBorder").size = new_minigame.minigame_size + minigame_border
	minigame_slots[minigame_slot].get_parent().find_child("gameBorder").global_position = minigame_slots[minigame_slot].get_parent().global_position - new_minigame.minigame_size/2 - minigame_border/2
	
	new_minigame.start()
	new_minigame.completed.connect(minigame_completed.bind(minigame_slot))
	new_minigame.failed.connect(minigame_failed.bind(minigame_slot))
	new_minigame.closed.connect(minigame_closed.bind(minigame_slot))

	for tv in tvs[minigame_slot]:
		tv.turnOn(new_minigame_viewport.get_path())
	
func minigame_completed(completion_event, minigame_slot):
	#current_rating += RATING_ON_MINIGAME_WIN
	print("COMPLETED MINIGAME WITH EVENT: %s" % completion_event)
	#animate_score("+" + str(RATING_ON_MINIGAME_WIN), minigame_slot)
	AudioHandler.playSound("clapping")
	
	
func minigame_failed(failure_event, minigame_slot):
	current_rating -= RATING_ON_MINIGAME_LOSS
	print("FAILED MINIGAME WITH EVENT: %s" % failure_event)
	animate_score("-" + str(RATING_ON_MINIGAME_LOSS), minigame_slot, true)
	AudioHandler.playSound("Boos")
	
func minigame_closed(slot):
	print("MINIGAME IN SLOT %s CLOSED" % slot)
	minigame_slots[slot].get_parent().find_child("gameBorder").visible = false
	minigames[slot].queue_free() 
	minigames[slot] = null
	for tv in tvs[slot]:
		tv.turnOff()

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

func on_rating_timer_timeout() -> void:
	current_rating -= RATING_LOSS_PER_SEC
	
func on_completed_word(word: Variant) -> void:
	if not current_state == GameState.PLAYING: return
	current_rating += RATING_ON_WORD
	current_rating = min(current_rating, MAX_RATING)

func on_incorrect_letter() -> void:
	if not current_state == GameState.PLAYING: return
	current_rating -= RATING_ON_TYPO

func animate_score(word: String, slot: String, lost: bool=false):
	# Create instance and set the word and position of animation
	var word_scene = word_animation_scene2D.instantiate()
	var minigame_viewport = minigames[slot].get_parent()
	var minigame_position = minigame_viewport.global_position
	var minigame_width = minigame_viewport.size.x / 2
	var minigame_height = minigame_viewport.size.y / 2
	
	var random_x_left = randf_range(minigame_position.x - minigame_width / 2 - 50, minigame_position.x - minigame_height / 2 - 25)
	var random_x_right = randf_range(minigame_position.x + minigame_width / 2 + 25, minigame_position.x + minigame_height / 2 + 50)
	var random_y = randf_range(minigame_position.y - minigame_height / 2 - 25, minigame_position.y + minigame_height / 2 + 25)
	var pos
	if slot == "slot_2" or slot == "slot_4": pos = Vector2(random_x_left, random_y)
	else: pos = Vector2(random_x_right, random_y)
	
	# Add instance to scene
	add_child(word_scene)
	word_scene.position = pos
	word_scene.set_word(word)
	if lost: word_scene.set_incorrect_material()
