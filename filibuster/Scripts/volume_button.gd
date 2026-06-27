extends TextureButton

var volume_level := 4

func _ready() -> void:
	pressed.connect(volumePressed)
	updateVolumeLevel(volume_level)
	
func volumePressed():
	AudioHandler.playSound("ui_click")
	volume_level = wrapi(volume_level-1, 0, 5)
	texture_normal = load("res://Assets/Graphics/VolumeButton/volume_button_%s.png" % volume_level)
	updateVolumeLevel(volume_level)

func updateVolumeLevel(level):
	AudioHandler.changeVolume(level/4.0)
