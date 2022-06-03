extends Particles2D


#freezes particles
func _on_Timer_timeout():
	speed_scale = 0
