extends Area2D

export (NodePath) var door_

func _process(delta):
	if door_:
		var door = get_node(door_)
		if get_overlapping_bodies() != []:
			door._open()
			print("F")
		if get_overlapping_areas() != []:
			door._open()
		else: door._close()
