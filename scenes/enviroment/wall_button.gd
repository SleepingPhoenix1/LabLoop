extends Area2D

export(NodePath) var door 
var can_press = true


func _on_wall_button_input_event(viewport, event, shape_idx):
	if $Area2D.get_overlapping_bodies() != [] and Input.is_action_just_pressed("shoot") and can_press:
		get_node(door).buttons_required -=1
		can_press = false
