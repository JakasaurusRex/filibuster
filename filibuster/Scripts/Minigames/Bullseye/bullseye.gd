extends "res://Scripts/Minigames/minigame_template_2d.gd"

## Number of targets that will be spawned
@export var num_targets = 5

@onready var targets_hit = 0
@onready var target = $Target
@onready var particles_scene = preload("res://Assets/Scenes/Minigames/Bullseye/shatter_particles.tscn")
var particles: Node2D
@onready var ICON_SIZE = minigame_size.x / 3

func _ready() -> void:
	target.size = Vector2(ICON_SIZE,ICON_SIZE)
	target_random_pos()

## Sets position of target with particles to random location on screen
func target_random_pos():
	particles = particles_scene.instantiate()
	add_child(particles)
	
	target.position = Vector2(randf_range(0,self.minigame_size.x-ICON_SIZE), randf_range(0,self.minigame_size.y-ICON_SIZE))
	particles.position = target.position + target.size / 2

func _on_target_pressed() -> void:
	targets_hit += 1
	particles.emitting = true
	print("Bullseye minigame: %s/%s target(s) hit" % [str(targets_hit), str(num_targets)])
	if targets_hit >= num_targets:
		win()
		close()
	target_random_pos()
