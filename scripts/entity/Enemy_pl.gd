extends KinematicBody2D

var velocity = Vector2()
var speed = 20
var gravity = 10

func _physics_process(delta):
	if $raycasts/RayCastLeft.is_colliding() == true:
		velocity.x = -speed
	elif $raycasts/RayCastRight.is_colliding() == true:
		velocity.x = speed
	else: 
		velocity.x = 0
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = 1
	move_and_slide(velocity, Vector2.UP)


func _on_DamageArea_body_entered(body):
	get_tree().reload_current_scene()
	
