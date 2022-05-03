extends Node2D

onready var color_swap = load("res://other/color_swap.tres")
onready var shooter_e = $enemies/shooter
onready var platformer_e = $enemies/platformer
onready var coins = $enviroment/coins

func _ready():
	Global.Health = 10
	GenreManager.current_level = 2
	if GenreManager.current_genre == 0:
		shooter_e.queue_free()
		color_swap.set_shader_param("color0", Color("FFFA4D"))
		color_swap.set_shader_param("color8", Color("5463FF"))
		color_swap.set_shader_param("color5", Color("353ea1"))
		if !SoundManager.stream == preload("res://sound/Labloop_Platformer_v1.mp3"):
			SoundManager.play_music(0)
	elif GenreManager.current_genre == 1:
		platformer_e.queue_free()
		coins.queue_free()
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("F24A72"))
		if !SoundManager.stream == preload("res://sound/Lab_Loop_Shooter_v2_Loopable.mp3"):
			SoundManager.play_music(1)
	elif GenreManager.current_genre == 2:
		platformer_e.queue_free()
		shooter_e.queue_free()
		coins.queue_free()
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("FDAF75"))
		if !SoundManager.stream == preload("res://sound/Labloop_Puzzle_v1.mp3"):
			SoundManager.play_music(2)
