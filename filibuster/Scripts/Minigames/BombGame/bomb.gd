extends Node3D

const wire_colors = ["red", "blue", "yellow", "green"]

const wire_materials = {
	"red": preload("res://Assets/Materials/Bomb/wires/red.tres"),
	"blue": preload("res://Assets/Materials/Bomb/wires/blue.tres"),
	"yellow": preload("res://Assets/Materials/Bomb/wires/yellow.tres"),
	"green": preload("res://Assets/Materials/Bomb/wires/green.tres"),
}

const light_materials = {
	"red": preload("res://Assets/Materials/Bomb/lights/red.tres"),
	"blue": preload("res://Assets/Materials/Bomb/lights/blue.tres"),
	"yellow": preload("res://Assets/Materials/Bomb/lights/yellow.tres"),
	"green": preload("res://Assets/Materials/Bomb/lights/green.tres"),
}
@onready var lights := [$Lights/Light1, $Lights/Light2, $Lights/Light3, $Lights/Light4]
@onready var wires = [$"Wires/1/wire", $"Wires/2/wire", $"Wires/3/wire", $"Wires/4/wire"]
@onready var cuts = [$"Wires/1/cut", $"Wires/2/cut", $"Wires/3/cut", $"Wires/4/cut"]

var light_order = []
var wire_order = []

var current_index = 0

signal completed()
signal exploded()

var over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	light_order = wire_colors.duplicate()
	wire_order = wire_colors.duplicate()
	light_order.shuffle()
	wire_order.shuffle()
	
	for i in range(len(light_order)):
		lights[i].set_material_override(light_materials[light_order[i]])
		wires[i].set_material_override(wire_materials[wire_order[i]])
		cuts[i].set_material_override(wire_materials[wire_order[i]])
		
func on_click(wire):
	if over: return
	
	var wire_num = int(wire.name) - 1
	var wire_color_clicked = wire_order[wire_num]
	
	wires[wire_num].visible = false
	cuts[wire_num].visible = true
	
	if wire_color_clicked == light_order[current_index]:
		current_index += 1
	else:
		emit_signal("exploded")
		over = true
		return
		
	if current_index == 4:
		emit_signal("completed")
		over = true
	
	pass
