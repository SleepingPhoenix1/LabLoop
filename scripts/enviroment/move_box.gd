extends Node2D

var selected = false


func _physics_process(delta):
	if selected and GenreManager.current_genre == 2:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		Input.set_custom_mouse_cursor(preload("res://sprites/cursors_puzzle.png"), Input.CURSOR_ARROW, Vector2(12,12))

func _input(event):
	if event is InputEventMouseButton and GenreManager.current_genre == 2:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			Input.set_custom_mouse_cursor(preload("res://sprites/cursor_puzzle_1.png"), Input.CURSOR_ARROW, Vector2(12,12))

func _on_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("shoot"):
		selected = true
		
