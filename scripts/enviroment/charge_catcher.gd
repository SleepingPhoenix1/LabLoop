extends Node2D

export(NodePath) var door
var can = true

func activate():
	if door and can:
		get_node(door).buttons_required -=1
		can = false
		$Node2D/ChargeCatcher.frame = 1
		print("D")
