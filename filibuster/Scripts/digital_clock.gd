extends Node2D

@onready var label = $CanvasLayer/Control/Label
@onready var timer = $Timer

@export var starting_time_hour = 12
var current_time_hour = starting_time_hour
var current_time_minute = 0
signal update_time(hour:int,minute:int)


func parse_time():
	var parsed_hour
	if current_time_hour < 10:
		parsed_hour = "0" + str(current_time_hour)
	elif current_time_hour > 12:
		parsed_hour = "0" + str(current_time_hour - 12)
	else:
		parsed_hour = str(current_time_hour)
	var parsed_minute
	if current_time_minute == 0:
		parsed_minute = "00"
	elif current_time_minute < 10:
		parsed_minute = "0" + str(int(current_time_minute))
	else:
		parsed_minute = str(int(current_time_minute))
	
	var am_or_pm 
	if current_time_hour >= 12:
		am_or_pm = "PM"
	else:
		am_or_pm = "AM"
	
	return parsed_hour + ":" + parsed_minute + " " + am_or_pm
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "Time: " + parse_time()
	timer.start(1)

func _on_timer_timeout() -> void:
	current_time_minute += .1
	if current_time_minute >= 60:
		current_time_hour += 1
		current_time_minute = 0
	label.text = "Time: " + parse_time()
	update_time.emit(current_time_hour, current_time_minute)
	timer.start(.1)
