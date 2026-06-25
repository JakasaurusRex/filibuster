extends Node3D

@onready var tvOnScreen := $tvOnScreen
@onready var tvOffScreen := $tvOffScreen

func _ready() -> void:
	turnOff()

func turnOn(vp):
	tvOnScreen.mesh.material.albedo_texture.viewport_path = vp
	tvOnScreen.visible = true
	tvOffScreen.visible = false
	
func turnOff():
	tvOnScreen.visible = false
	tvOffScreen.visible = true
