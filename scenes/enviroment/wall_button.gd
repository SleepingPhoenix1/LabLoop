extends Area2D

export(NodePath) var door 
var can_press = true


# warning-ignore:unused_argument
func _process(delta):
	if ($Area2D2.get_overlapping_areas() != [] or get_overlapping_bodies() != []) and can_press:
		get_node(door).buttons_required -=1
		can_press = false
		$WallButton.frame = 1
