extends Node2D

export(NodePath) var door


var trigger_once = true

#decreases the buttons needed for the door
func activate():
	if door and trigger_once:
		get_node(door).buttons_required -=1
		trigger_once = false
		$Node2D/ChargeCatcher.frame = 1
