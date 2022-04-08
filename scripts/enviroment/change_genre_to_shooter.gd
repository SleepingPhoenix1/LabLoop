extends Area2D




func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		GenreManager.change_genre_to(GenreManager.current_genre +1)
		get_tree().reload_current_scene()
