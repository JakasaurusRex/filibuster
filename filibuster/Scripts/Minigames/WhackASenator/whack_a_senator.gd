extends Minigame

@onready var camera := $Camera3D
@onready var fils := {
	"fil1": $fils/fil1,
	"fil2": $fils/fil2,
	"fil3": $fils/fil3,
	"fil4": $fils/fil4,
	"fil5": $fils/fil5,
}

@onready var fil_areas := {
	"fil1": $fils/fil1/filArea,
	"fil2": $fils/fil2/filArea,
	"fil3": $fils/fil3/filArea,
	"fil4": $fils/fil4/filArea,
	"fil5": $fils/fil5/filArea,
}
@onready var fil_status := {
	"fil1": "down",
	"fil2": "down",
	"fil3": "down",
	"fil4": "down",
	"fil5": "down",
}

@onready var filRaiseTimer := $filRaiseTimer
@onready var filLowerTimer := $filLowerTimer

var score := 0
const WIN_SCORE := 10
const RAY_LENGTH := 10

func _ready() -> void:
	filRaiseTimer.timeout.connect(raiseRandomFil)
	filLowerTimer.timeout.connect(lowerRandomFil)
	
func win():
	super.win()
	emit_signal("completed", "PLAYER WON WHACK A FIL GAME")
	close()

func lose():
	super.lose()
	emit_signal("finished", "PLAYER LOST WHACK A FIL GAME")
	close()

func raiseRandomFil():
	filRaiseTimer.start(randf_range(0.5, 1.0))
	var down_fils = fils.keys().filter(func (f): return fil_status[f] == "down")
	if down_fils == []: 
		print("NO FILS") 
		return
	var new_up_fil = down_fils.pick_random()
	fil_status[new_up_fil] = "transition"
	var fil_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	fil_tween.tween_property(fils[new_up_fil], "global_position", fils[new_up_fil].global_position + Vector3.UP * .25, 0.35)
	fil_tween.tween_callback(fillRaised.bind(new_up_fil))

func lowerRandomFil():
	filLowerTimer.start(randf_range(1.0, 1.5))
	var up_fils = fils.keys().filter(func (f): return fil_status[f] == "up")
	if len(up_fils) <= 2: 
		print("NO FILS") 
		return
	var new_down_fil = up_fils.pick_random()
	fil_status[new_down_fil] = "transition"
	var fil_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	fil_tween.tween_property(fils[new_down_fil], "global_position", fils[new_down_fil].global_position - Vector3.UP * .25, 0.35)
	fil_tween.tween_callback(fillLowered.bind(new_down_fil))
	
func fillRaised(fil):
	fil_status[fil] = "up"

func fillLowered(fil):
	fil_status[fil] = "down"
	
func filWhacked(fil):
	score += 1
	if score >= 10:
		win()
	fil_status[fil] = "transition"
	var fil_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	fil_tween.tween_property(fils[fil], "global_position", fils[fil].global_position - Vector3.UP * .25, 0.35)
	fil_tween.tween_callback(fillLowered.bind(fil))
	
func ray_cast():
	var space_state = camera.get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_pos)
	var end = origin + camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	result = result.get("collider")
	return result

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		var ray_cast_result = ray_cast()
		if ray_cast_result is StaticBody3D: return
		var possible_fil = ray_cast_result.get_parent().name
		if possible_fil in fils and fil_status[possible_fil] == "up": 
			filWhacked(ray_cast_result.get_parent().name)
		
