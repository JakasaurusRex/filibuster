extends AudioStreamPlayer

class_name AnimalesePlayer

signal finished_phrase()

const PITCH_MULTIPLIER_RANGE := 0.3
const INFLECTION_SHIFT := 0.4

@export var base_pitch := 3.5 # (float, 2.5, 4.5)

const root_path = "res://Assets/Sounds/animalese/"
const jake_path = "/sounds_jake/"

# All the possible sounds
const sounds = ["a","i","u","e","o","ka","ki","ku","ke","ko","ga","gi","gu","ge","go","sa","shi","su","se","so","za","zi","zu","ze","zo","ta","chi","tsu","te","to","da","di","du","de","do","na","ni","nu","ne","no","ma","mi","mu","me","mo","ha","hi","hu","he","ho","fa","fi","fu","fe","fo","pa","pi","pu","pe","po","ra","ri","ru","re","ro","wa","ya","yu","yo"]

# The actual SFX
const jake_sounds = {
	'a': preload(root_path + jake_path + "a.wav"),
	'e': preload(root_path + jake_path + "e.wav"),
	'i': preload(root_path + jake_path + "i.wav"),
	'o': preload(root_path + jake_path + "o.wav"),
	'u': preload(root_path + jake_path + "u.wav"),
	'ka': preload(root_path + jake_path + "ka.wav"),
	'ki': preload(root_path + jake_path + "ki.wav"),
	'ku': preload(root_path + jake_path + "ku.wav"),
	'ke': preload(root_path + jake_path + "ke.wav"),
	'ko': preload(root_path + jake_path + "ko.wav"),
	'ga': preload(root_path + jake_path + "ga.wav"),
	'gi': preload(root_path + jake_path + "gi.wav"),
	'gu': preload(root_path + jake_path + "gu.wav"),
	'ge': preload(root_path + jake_path + "ge.wav"),
	'go': preload(root_path + jake_path + "go.wav"),
	'sa': preload(root_path + jake_path + "sa.wav"),
	'shi': preload(root_path + jake_path + "shi.wav"),
	'su': preload(root_path + jake_path + "su.wav"),
	'se': preload(root_path + jake_path + "se.wav"),
	'so': preload(root_path + jake_path + "so.wav"),
	'za': preload(root_path + jake_path + "za.wav"),
	'zi': preload(root_path + jake_path + "zi.wav"),
	'zu': preload(root_path + jake_path + "zu.wav"),
	'ze': preload(root_path + jake_path + "ze.wav"),
	'zo': preload(root_path + jake_path + "zo.wav"),
	'ta': preload(root_path + jake_path + "ta.wav"),
	'chi': preload(root_path + jake_path + "chi.wav"),
	'tsu': preload(root_path + jake_path + "tsu.wav"),
	'te': preload(root_path + jake_path + "te.wav"),
	'to': preload(root_path + jake_path + "to.wav"),
	'da': preload(root_path + jake_path + "da.wav"),
	'di': preload(root_path + jake_path + "di.wav"),
	'du': preload(root_path + jake_path + "du.wav"),
	'de': preload(root_path + jake_path + "de.wav"),
	'do': preload(root_path + jake_path + "do.wav"),
	'na': preload(root_path + jake_path + "na.wav"),
	'ni': preload(root_path + jake_path + "ni.wav"),
	'nu': preload(root_path + jake_path + "nu.wav"),
	'ne': preload(root_path + jake_path + "ne.wav"),
	'no': preload(root_path + jake_path + "no.wav"),
	'ma': preload(root_path + jake_path + "ma.wav"),
	'mi': preload(root_path + jake_path + "mi.wav"),
	'mu': preload(root_path + jake_path + "mu.wav"),
	'me': preload(root_path + jake_path + "me.wav"),
	'mo': preload(root_path + jake_path + "mo.wav"),
	'ha': preload(root_path + jake_path + "ha.wav"),
	'hi': preload(root_path + jake_path + "hi.wav"),
	'hu': preload(root_path + jake_path + "hu.wav"),
	'he': preload(root_path + jake_path + "he.wav"),
	'ho': preload(root_path + jake_path + "ho.wav"),
	'fa': preload(root_path + jake_path + "fa.wav"),
	'fi': preload(root_path + jake_path + "fi.wav"),
	'fu': preload(root_path + jake_path + "fu.wav"),
	'fe': preload(root_path + jake_path + "fe.wav"),
	'fo': preload(root_path + jake_path + "fo.wav"),
	'pa': preload(root_path + jake_path + "pa.wav"),
	'pi': preload(root_path + jake_path + "pi.wav"),
	'pu': preload(root_path + jake_path + "pu.wav"),
	'pe': preload(root_path + jake_path + "pe.wav"),
	'po': preload(root_path + jake_path + "po.wav"),
	'ra': preload(root_path + jake_path + "ra.wav"),
	'ri': preload(root_path + jake_path + "ri.wav"),
	'ru': preload(root_path + jake_path + "ru.wav"),
	're': preload(root_path + jake_path + "re.wav"),
	'ro': preload(root_path + jake_path + "ro.wav"),
	'wa': preload(root_path + jake_path + "wa.wav"),
	'ya': preload(root_path + jake_path + "ya.wav"),
	'yu': preload(root_path + jake_path + "yu.wav"),
	'yo': preload(root_path + jake_path + "yo.wav"),
}

# Add your name here
const voices = [jake_sounds]

var remaining_sounds := []

func _ready():
	connect("finished", play_sounds)

func play_word(word: String):
	var voice = voices[randi_range(0, len(voices) - 1)]
	parse_word(word)
	await play_sounds(voice)

func play_sounds(voice):
	while len(remaining_sounds) > 0:			
		var next_symbol = remaining_sounds.pop_front()
		# Skip to next sound if no sound exists for text
		if next_symbol == '':
			continue
		var sound: AudioStreamWAV = voice[next_symbol]
		# Add some randomness to pitch
		pitch_scale = base_pitch + (PITCH_MULTIPLIER_RANGE * randf())
		stream = sound
		play()
		# wait for .1 seconds between the sounds
		await get_tree().create_timer(0.1).timeout
	emit_signal("finished_phrase")


func parse_word(word: String):
	for i in range(len(word)):
		remaining_sounds.append(sounds[randi() % len(sounds)])
	
