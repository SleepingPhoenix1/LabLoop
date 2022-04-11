extends Area2D




func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if GenreManager.current_genre == 0:
			GenreManager.current_genre = 1
		elif GenreManager.current_genre == 1:
			GenreManager.current_genre = 2
		elif GenreManager.current_genre == 2:
			GenreManager.current_genre = 0
		get_tree().reload_current_scene()
