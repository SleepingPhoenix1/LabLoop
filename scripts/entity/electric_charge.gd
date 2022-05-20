extends Area2D

var velocity = Vector2(0,1)
var speed = 125

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
	set_deferred("monitoring", false)
	velocity = Vector2.ZERO
	$Timer.start()



func _on_Area2D_body_entered(body):
	if body.is_in_group("b_left"):
		rotation_degrees += 90
		body.get_parent().direction = -1
	elif body.is_in_group("b_right"):
		rotation_degrees -= 90
		body.get_parent().direction = 1
	elif body.is_in_group("charge_catcher"):
		body.get_parent().activate()
		explode()
	else:
		explode()
		$SoundPlayer.stream = load("res://sound/charge_collide.wav")
		$SoundPlayer.play()
		if body.is_in_group("player"):
			Global.hurt()
			


func _on_Timer_timeout():
	queue_free()
