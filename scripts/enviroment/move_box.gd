extends Node2D

var selected = false

func _process(delta):
	pass



func _physics_process(delta):
	if selected and GenreManager.current_genre == 2:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false


func _on_area_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("shoot"):
		selected = true
		
