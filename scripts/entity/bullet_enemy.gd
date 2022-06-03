extends Area2D

var velocity = Vector2(1,0)
var speed = 169#nice

var look_once = true

var is_exploiding = false


func _ready():
	randomize()

func _process(delta):
	#sets direction to mouse vector
	if look_once:
		#makes that bullet might sometimes miss
		look_at(Global.Player.global_position+Vector2(rand_range(-5,5),rand_range(-5,5)))
		look_once = false
		$Explosion.start()
	#rotates velocity to a node rotation and moves it in that direction
	global_position += velocity.rotated(rotation) * speed * delta
	

#remove when exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#freezes the bullet and plays particle
func explode():
	$explosion.emitting = true
	$Bullet.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	$Timer.start()

#when bullet goes too far explode the bullet
func _on_Explosion_timeout():
	explode()

#if bullet collides with player - hurt the player and explode the bullet
func _on_Area2D_body_entered(body):
	explode()
	if body.is_in_group("player"):
		Global.hurt(true)
		Global.hit_bullet = velocity

#when particle is finished - delete the bullet
func _on_Timer_timeout():
	queue_free()
