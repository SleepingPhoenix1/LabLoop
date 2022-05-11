extends Node2D


func _process(delta):
	look_at(get_global_mouse_position())
	scale.y = sign(get_global_mouse_position().x-Global.Player.global_position.x)
