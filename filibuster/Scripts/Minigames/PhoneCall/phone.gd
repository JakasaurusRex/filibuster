extends Node3D

@onready var numbers = {
	$One: "one",
	$Two: "two",
	$Three: "three",
	$Four: "four",
	$Five: "five",
	$Six: "six",
	$Seven: "seven",
	$Eight: "eight",
	$Nine: "nine",
	$Zero: "zero",
	$Clear:"clear",
	$Call: "submit",
}

@onready var animation_player = $AnimationPlayer
@onready var number_label = $Screen/Number

signal call_successful()
signal call_failed()
var called = false

var current_string = ""
var correct_string = "7674206967"

func on_click(object):
	var number = numbers[object]
	if !number: return
	
	animation_player.play(number)
	if called: return
	
	if number == "clear":
		current_string = ""
		return
	elif number =="submit":
		if current_string == correct_string:
			emit_signal("call_successful")
		else:
			emit_signal("call_failed")
			
		called = true
		return
	
	if len(current_string) < 9:
		current_string += number
	

func _process(delta: float) -> void:
	number_label.text = current_string
