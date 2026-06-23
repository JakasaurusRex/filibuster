extends Node3D

@onready var timer = $Timer
@onready var hour_pivot = $ClockFace/HourPivot
@onready var minute_pivot = $ClockFace/MinutePivot
const HOUR_DEGREE = 360 / 12
const HOUR_MINUTE_DEGREE = 360.0 / 12.0 / 60.0
const MINUTE_DEGREE = 360 / 60

## Changes the analog clock to appear as the inputted time
func set_time(hour, minute):
	hour = float(fmod(hour,12))
	minute = fmod(minute, 60)
	hour_pivot.rotation_degrees = Vector3(0, 0, -hour*HOUR_DEGREE-minute*HOUR_MINUTE_DEGREE)
	minute_pivot.rotation_degrees = Vector3(0, 0, -minute*MINUTE_DEGREE)


func _on_digital_clock_update_time(hour, minute) -> void:
	set_time(hour, minute)
