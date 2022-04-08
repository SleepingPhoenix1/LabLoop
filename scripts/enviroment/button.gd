extends Area2D

export (NodePath) var door

func _process(delta):
	if get_overlapping_bodies() != []:
		pass
	if get_overlapping_areas() != []:
		pass
