extends Node3D

@onready var timer = $Timer
@onready var hour_pivot = $ClockFace/HourPivot
@onready var minute_pivot = $ClockFace/MinutePivot
#@onready var tween = get_tree().create_tween()
const HOUR_DEGREE = 30
const HOUR_MINUTE_DEGREE = 360.0 / 12.0 / 60.0
const MINUTE_DEGREE = 6


## Changes the analog clock to appear as the inputted time
func parse_time(hour, minute, delta:float=.333333):
	hour = float(fmod(hour,12))
	minute = fmod(minute, 60)
	#hour_pivot.rotation_degrees = Vector3(0, 0, -hour*HOUR_DEGREE-minute*HOUR_MINUTE_DEGREE)
	#minute_pivot.rotation_degrees = Vector3(0, 0, -minute*MINUTE_DEGREE)
	hour_pivot.rotation.z = lerp_angle(hour_pivot.rotation.z, deg_to_rad(-hour*HOUR_DEGREE-minute*HOUR_MINUTE_DEGREE), delta)
	minute_pivot.rotation.z = lerp_angle(minute_pivot.rotation.z, deg_to_rad(-minute*MINUTE_DEGREE), delta)
