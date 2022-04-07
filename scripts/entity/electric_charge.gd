extends Area2D

var velocity = Vector2(0,1)
var speed = 175

var look_once = true
var is_exploiding = false



func _ready():
	pass

func _process(delta):
	if look_once:
		look_once = false
	global_position += velocity.rotated(rotation) * speed * delta
	
	if !$explosion.emitting and is_exploiding:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func explode():
	$explosion.emitting = true
	$ElectricStuff.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	is_exploiding = true



func _on_Area2D_body_entered(body):
	if body.is_in_group("b_left"):
		rotate(1.55)
	elif body.is_in_group("b_right"):
		rotate(-1.55)
	else:
		explode()
		if body.is_in_group("player"):
			Global.Health -=1
