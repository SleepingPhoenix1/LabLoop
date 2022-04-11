extends KinematicBody2D

var velocity = Vector2()
export var speed = 20
var gravity = 10
var sleeping = true

func _physics_process(_delta):
	if Global.Player:
		if $raycasts/RayCastLeft.get_collider() == Global.Player:
			$SleepTimer.stop()
			if sleeping:
				$AnimationPlayer.play("wake_up")
			else: 
				$AnimationPlayer.play("walk")
				velocity.x = -speed
		elif $raycasts/RayCastRight.get_collider() == Global.Player:
			
			if sleeping:
				$AnimationPlayer.play("wake_up")
			else: 
				$AnimationPlayer.play("walk")
				velocity.x = speed
			
		else: 
			velocity.x = 0
			if $AnimationPlayer.current_animation == "walk" or $AnimationPlayer.current_animation == "wake_up":
				$SleepTimer.start()
				$AnimationPlayer.play("idle")
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = 1
	velocity = move_and_slide(velocity, Vector2.UP)
	$Robot.flip_h = true if velocity.x <0 else false

func _on_DamageArea_body_entered(body):
	Global.Health -=1
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "wake_up":
		sleeping = false


func _on_SleepTimer_timeout():
	$AnimationPlayer.play("to_sleep")
	sleeping = true
