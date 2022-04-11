extends Area2D

var can_press = true
export var id = 0

func _process(_delta):
	if ($Area2D2.get_overlapping_areas() != [] or get_overlapping_bodies() != []) and can_press:
		can_press = false
		$WallButton.frame = 1
		if id == 0:
			get_tree().change_scene("res://scenes/levels/Level1.tscn")
			GenreManager.current_genre = 0
		elif id == 1:
			pass
		elif id == 2:
			get_tree().quit()
		elif id == 3:
			get_tree().change_scene("res://scenes/levels/Main menu.tscn")
