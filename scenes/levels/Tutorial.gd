extends Node2D

onready var color_swap = load("res://other/color_swap.tres")
func _ready():
	GenreManager.current_genre = 1
	Global.Health = 10
	if GenreManager.current_genre == 0:
		color_swap.set_shader_param("color0", Color("FFFA4D"))
		color_swap.set_shader_param("color8", Color("5463FF"))
		color_swap.set_shader_param("color5", Color("353ea1"))
		if !SoundManager.stream == load("res://sound/Labloop_Platformer_v1.mp3"):
			SoundManager.play_music(0)
	elif GenreManager.current_genre == 1:
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("F24A72"))
		if !SoundManager.stream == load("res://sound/Lab_Loop_Shooter_v1a_Loopable.mp3"):
			SoundManager.play_music(1)
	elif GenreManager.current_genre == 2:
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("FDAF75"))
		if !SoundManager.stream == load("res://sound/Labloop_Puzzle_v1.mp3"):
			SoundManager.play_music(2)
