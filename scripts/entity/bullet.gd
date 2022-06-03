extends Area2D

var velocity = Vector2(1,0)
var speed = 250

var look_once = true

func _ready():
	pass

func _process(delta):
	#sets direction to mouse vector
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
		$Explosion.start()
	#rotates velocity to a node rotation and moves it in that direction
	global_position += velocity.rotated(rotation) * speed * delta
	


#remove when exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#when bullet goes too far explode the bullet
func _on_Explosion_timeout():
	explode()

#freezes the bullet and plays particle
func explode():
	$explosion.emitting = true
	$Bullet.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	$Timer.start()


#collision detection
func _on_Area2D_body_entered(_body):
	explode()

#when particle is finished - delete the bullet
func _on_Timer_timeout():
	queue_free()
