extends Area2D

var velocity = Vector2(1,0)
var speed = 250

var look_once = true
var is_exploiding = false

func _ready():
	pass

func _process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
		$Explosion.start()
	global_position += velocity.rotated(rotation) * speed * delta
	
	if !$explosion.emitting and is_exploiding:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Explosion_timeout():
	explode()

func explode():
	$explosion.emitting = true
	$Bullet.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	$Timer.start()



func _on_Area2D_body_entered(body):
	explode()


func _on_Timer_timeout():
	queue_free()
