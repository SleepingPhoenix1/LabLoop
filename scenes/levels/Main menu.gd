extends Node2D

onready var color_swap = preload("res://other/color_swap.tres")
func _ready():
	Global.Health = 10
	GenreManager.current_level = 1
	if GenreManager.current_genre == 0:
		color_swap.set_shader_param("color0", Color("FFFA4D"))
		color_swap.set_shader_param("color8", Color("5463FF"))
	elif GenreManager.current_genre == 1:
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("F24A72"))
	elif GenreManager.current_genre == 2:
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("FDAF75"))


