extends Node2D

var selected = false
var direction

func _physics_process(delta):
	if selected and GenreManager.current_genre == 2:
		global_position = lerp(global_position, Vector2(get_global_mouse_position().x,get_global_mouse_position().y+8), 25 * delta)
		Input.set_custom_mouse_cursor(preload("res://sprites/cursors_puzzle.png"), Input.CURSOR_ARROW, Vector2(12,12))
		$box/AnimatedSprite.frames.set_animation_speed("def", 5)
		$shake.play("shake")
	elif !selected:
		$box/AnimatedSprite.frames.set_animation_speed("def", 1.5)
		$shake.play("RESET")
	$worried.emitting = selected
	$worried2.emitting = selected
	if direction == 1:
		$box/AnimatedSprite.play("charge_in")
		direction = null
	elif direction == -1:
		$box/AnimatedSprite.play("charge_in")
		direction = null

func _input(event):
	if event is InputEventMouseButton and GenreManager.current_genre == 2:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			Input.set_custom_mouse_cursor(preload("res://sprites/cursor_puzzle_1.png"), Input.CURSOR_ARROW, Vector2(12,12))

func _on_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("shoot"):
		selected = true
		

func _ready():
	if GenreManager.current_genre ==2:
		$box.set_collision_mask_bit(2, false)

