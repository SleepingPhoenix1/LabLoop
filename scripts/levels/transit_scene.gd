extends Control




func _ready():
	if GenreManager.current_genre == 0:
		$LevelComplete_1.play("level_complete2")
		GenreManager.current_genre = 1
	elif GenreManager.current_genre == 1:
		$LevelComplete_1.play("level_complete")
		GenreManager.current_genre = 2
	elif GenreManager.current_genre == 2:
		$LevelComplete_1.play("level_complete3")
		$LevelComplete_2.play("level_complete")
		$LevelComplete_3.play("level_complete2")
		GenreManager.current_genre = 3


func _on_Timer_timeout():
	$LevelComplete_1.play("fade_in")


func _on_LevelComplete_1_animation_finished(anim_name):
	if anim_name == "fade_in":
		level_switcher()

func level_switcher():
	if GenreManager.current_level == 2:
		if GenreManager.current_genre == 3:
			get_tree().change_scene("res://scenes/levels/Level3.tscn")
			GenreManager.current_genre = 0
		else: 
			get_tree().change_scene("res://scenes/levels/Level2.tscn")
	elif GenreManager.current_level == 3:
		if GenreManager.current_genre == 3:
			get_tree().change_scene("res://scenes/levels/Level4.tscn")
			GenreManager.current_genre = 0
		else: 
			get_tree().change_scene("res://scenes/levels/Level3.tscn")
	elif GenreManager.current_level == 4:
		if GenreManager.current_genre == 3:
			get_tree().change_scene("res://scenes/levels/Level4.tscn")
			GenreManager.current_genre = 0
		else: 
			get_tree().change_scene("res://scenes/levels/Level4.tscn")
