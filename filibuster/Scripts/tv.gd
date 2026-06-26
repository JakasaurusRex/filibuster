extends Node3D

@onready var tvOnScreen := $tvOnScreen
@onready var tvOffScreen := $tvOffScreen

func _ready() -> void:
	turnOff()

func turnOn(vp):
	tvOnScreen.mesh.surface_get_material(0).albedo_texture.viewport_path = vp
	tvOnScreen.visible = true
	tvOffScreen.visible = false
	
func turnOff():
	#tvOnScreen.mesh.surface_get_material(0).albedo_texture = null
	tvOnScreen.visible = false
	tvOffScreen.visible = true
