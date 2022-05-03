extends Node2D

onready var color_swap = load("res://other/color_swap.tres")
func _ready():
	GenreManager.current_level = 0
	if GenreManager.current_genre == 0:
		color_swap.set_shader_param("color0", Color("FFFA4D"))
		color_swap.set_shader_param("color8", Color("5463FF"))
		color_swap.set_shader_param("color5", Color("353ea1"))
