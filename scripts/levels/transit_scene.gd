extends Control




func _ready():
	SoundManager.play_music(3)
	if GenreManager.current_genre == 0:
		$LevelComplete_1.play("level_complete2")
		GenreManager.current_genre = 1
	elif GenreManager.current_genre == 1:
		$"CenterContainer/Transit1-Sheet/Transit1-Sheet2".frame = 4
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
	if GenreManager.current_level == 1:
		if GenreManager.current_genre == 3:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level2.tscn")
			GenreManager.current_genre = 0
		else: 
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level1.tscn")
	elif GenreManager.current_level == 2:
		if GenreManager.current_genre == 3:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level3.tscn")
			GenreManager.current_genre = 0
		else: 
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level2.tscn")
	elif GenreManager.current_level == 3:
		if GenreManager.current_genre == 3:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level4.tscn")
			GenreManager.current_genre = 0
		else: 
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level3.tscn")
	elif GenreManager.current_level == 4:
		if GenreManager.current_genre == 3:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level5.tscn")
			GenreManager.current_genre = 0
		else: 
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level4.tscn")
	elif GenreManager.current_level == 5:
		if GenreManager.current_genre == 3:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/end.tscn")
			GenreManager.current_genre = 0
		else: 
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/levels/Level5.tscn")
