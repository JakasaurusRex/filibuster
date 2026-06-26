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
	$Call: "call",
}

const string_to_num = {
	"one": 1,
	"two": 2,
	"three": 3,
	"four": 4,
	"five": 5,
	"six": 6,
	"seven": 7,
	"eight": 8,
	"nine": 9,
	"zero": 0,
}

@onready var animation_player = $AnimationPlayer
@onready var number_label = $Screen/Number
@onready var timer = $Timer
signal call_successful()
signal call_failed()
var called = false

var current_string = ""
var correct_string = "7674206967"

func did_call():
	called = true
	AudioHandler.playSound("phone_ring")
	timer.start(1.0)

func on_click(object):
	var number = numbers[object]
	if !number: return
	
	if animation_player.is_playing(): return
	animation_player.play(number)
	if called: return
	
	AudioHandler.playSound("PhoneBeep")
	
	if number == "clear":
		current_string = ""
		return
	elif number =="call":
		if len(current_string) == 0: return 
		did_call()
		return
	
	if len(current_string) < 10:
		current_string += str(string_to_num[number])
	

func _process(delta: float) -> void:
	number_label.text = current_string


func on_timer_timeout() -> void:
	if current_string == correct_string: emit_signal("call_successful")
	else: emit_signal("call_failed")
