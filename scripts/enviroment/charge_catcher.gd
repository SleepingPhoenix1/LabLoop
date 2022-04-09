extends Node2D

export(NodePath) var door
var can = true

func activate():
	if door and can:
		get_node(door).buttons_required -=1
		can = false
		print("D")
