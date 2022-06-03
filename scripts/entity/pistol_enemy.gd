extends Node2D

var _global_position
var enemy
var player_visible

func _process(delta):
	_global_position = $Sprite/shoot_pos.global_position
	if player_visible:
		look_at(Global.Player.global_position)
		scale.y = sign(Global.Player.global_position.x-enemy.global_position.x)
