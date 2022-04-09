extends Node2D

onready var color_swap = preload("res://other/color_swap.tres")
onready var shooter_e = $enemies/shooter
onready var platformer_e = $enemies/platformer

func _ready():
	if GenreManager.current_genre == 0:
		shooter_e.queue_free()
		color_swap.set_shader_param("color0", Color.black)
		color_swap.set_shader_param("color8", Color.white)
	elif GenreManager.current_genre == 1:
		platformer_e.queue_free()
		color_swap.set_shader_param("color0", Color("e06464"))
		color_swap.set_shader_param("color8", Color("4d5e2b"))
	elif GenreManager.current_genre == 2:
		platformer_e.queue_free()
		shooter_e.queue_free()
		color_swap.set_shader_param("color0", Color("e06464"))
		color_swap.set_shader_param("color8", Color("4d5e2b"))
