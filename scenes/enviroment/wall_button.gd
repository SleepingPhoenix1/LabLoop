extends Area2D

export(NodePath) var door 
var can_press = true


func _process(_delta):
	if $Area2D.get_overlapping_bodies() != [] and $Area2D2.get_overlapping_areas() != [] and can_press:
		get_node(door).buttons_required -=1
		can_press = false
		$WallButton.frame = 1
