extends Area2D

var can_press = true
export var id = 0

func _process(_delta):
	if get_overlapping_bodies() != [] and can_press:
		can_press = false
		$WallButton.frame = 1
		if id == 0:
			
			get_tree().change_scene("res://scenes/levels/Level"+str(GenreManager.current_level)+".tscn")
			GenreManager.current_genre = 0
		elif id == 1:
			get_tree().change_scene("res://scenes/levels/Tutorial.tscn")
		elif id == 2:
			get_tree().quit()
		elif id == 3:
			get_tree().change_scene("res://scenes/levels/Main menu.tscn")


func _on_Menu_button_body_exited(body):
	$WallButton.frame = 0
	can_press = true
