extends Node2D

var _global_position

func _process(delta):
	_global_position = $Sprite/shoot_pos.global_position
	look_at(get_global_mouse_position())
	scale.y = sign(get_global_mouse_position().x-Global.Player.global_position.x)
