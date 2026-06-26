extends Node
@onready var soundQueue := $soundEffectQueue
@onready var bgMusicPlayer := $bgMusicPlayer
@onready var players := []
@onready var queue_length := 10
@onready var queue_index := 0
@onready var queue_3d_index := 0

const HAS_MULTIPLE_FILES := ["test_sounds", "EnergyDrink", "Bullseye", "typing_sounds", "Boos"]
const SOUND_DIR := "res://Assets/Sounds/"
var music_tween 

func _ready():
	populateQueues()

func populateQueues():
	for x in range(queue_length):
		var new_player = AudioStreamPlayer.new()
		soundQueue.add_child(new_player)
		#new_player.bus = "soundEffects"
		#new_3d_player.bus = "soundEffects"
		players.append(new_player)

func playSound(audio):
	var current_player : AudioStreamPlayer = players[queue_index] 
	queue_index = wrapi(queue_index+1, 0, queue_length-1)
	if current_player.playing: current_player.stop()
	current_player.stream = getAudio(audio)
	current_player.play()
	
func getAudio(audio):
	var audio_name = audio
	if audio_name in HAS_MULTIPLE_FILES: 
		var audio_dir = SOUND_DIR + audio_name
		var audio_files = Array(DirAccess.get_files_at(audio_dir)).filter(func (file): return not file.ends_with("import"))
		print(audio_files)
		audio_name = "%s/%s" % [audio_name, audio_files.pick_random()]
	else:
		audio_name += ".wav"
	var sound_stream = load(SOUND_DIR+audio_name)
	return sound_stream
	
func setPlayer(player, val):
	match player:
		"music": bgMusicPlayer.volume_db = val
		pass

func tweenPlayer(player, val, time=1.0):
	match player:
		"music": 
			if music_tween: music_tween.kill()
			music_tween = get_tree().create_tween()
			music_tween.tween_property(bgMusicPlayer, "volume_db", val, time)
		pass
		
func togglePlayer(player, on):
	match player:
		"music": bgMusicPlayer.playing = on
		pass

#func setPlayerStream(player, stream):
	#match player:
		#"music": bgMusicPlayer.stream = AudioHandler.getAudio(stream)
