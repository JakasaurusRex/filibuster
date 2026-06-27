extends Node2D

@onready var label = $CanvasLayer/Control/Label

#@export var starting_time_hour = 12
#var current_time_hour = starting_time_hour
#var current_time_minute = 0

signal update_time(hour:int,minute:int)


func parse_time(hour, minute):
	var parsed_hour
	if hour < 10:
		parsed_hour = "0" + str(hour)
	elif hour > 12:
		parsed_hour = "0" + str(hour - 12)
	else:
		parsed_hour = str(hour)
	var parsed_minute
	if minute == 0:
		parsed_minute = "00"
	elif minute < 10:
		parsed_minute = "0" + str(minute)
	else:
		parsed_minute = str(minute)
	
	var am_or_pm 
	if hour >= 12:
		am_or_pm = "PM"
	else:
		am_or_pm = "AM"
	
	label.text = " " + parsed_hour + ":" + parsed_minute + " " + am_or_pm
		

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#label.text = "Time: " + parse_time(current_time_hour, current_time_minute)
