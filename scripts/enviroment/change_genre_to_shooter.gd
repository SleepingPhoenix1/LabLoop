extends Area2D

#change the genre (genre+=1)
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		Global.Player.finish()
