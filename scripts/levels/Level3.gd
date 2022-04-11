extends Node2D

onready var color_swap = preload("res://other/color_swap.tres")
onready var shooter_e = $enemies/shooter
onready var platformer_e = $enemies/platformer
onready var coins = $enviroment/coins

func _ready():
	if GenreManager.current_genre == 0:
		shooter_e.queue_free()
		color_swap.set_shader_param("color0", Color("FFFA4D"))
		color_swap.set_shader_param("color8", Color("5463FF"))
	elif GenreManager.current_genre == 1:
		platformer_e.queue_free()
		coins.queue_free()
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("F24A72"))
	elif GenreManager.current_genre == 2:
		platformer_e.queue_free()
		shooter_e.queue_free()
		coins.queue_free()
		color_swap.set_shader_param("color0", Color("333C83"))
		color_swap.set_shader_param("color8", Color("FDAF75"))
	elif GenreManager.current_genre == 2:
		get_tree().change_scene("res://scenes/levels/Level4.tscn")
		GenreManager.current_genre = 0
