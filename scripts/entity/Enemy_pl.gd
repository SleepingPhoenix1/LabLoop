extends KinematicBody2D

var velocity = Vector2()
export var speed = 20
var gravity = 10
var sleeping = true
export var _print = false

func _physics_process(_delta):
	if _print:
		print($AnimationPlayer.current_animation)
	if Global.Player:
		if $raycasts/RayCastLeft.get_collider() == Global.Player:
			$SleepTimer.stop()
			if sleeping:
				$AnimationPlayer.play("wake_up")
			else: 
				$AnimationPlayer.play("walk")
				$SleepTimer.stop()
				velocity.x = -speed
		elif $raycasts/RayCastRight.get_collider() == Global.Player:
			
			if sleeping:
				$AnimationPlayer.play("wake_up")
			else: 
				$AnimationPlayer.play("walk")
				$SleepTimer.stop()
				velocity.x = speed
			
		else: 
			velocity.x = 0
			if $AnimationPlayer.current_animation == "walk" and !$AnimationPlayer.current_animation == "wake_up":
				$SleepTimer.start()
				$AnimationPlayer.play("idle")
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = 1
	velocity = move_and_slide(velocity, Vector2.UP)
	$Robot.flip_h = true if velocity.x <0 else false

func _on_DamageArea_body_entered(_body):
	Global.hurt()
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "wake_up":
		sleeping = false
		if !$raycasts/RayCastLeft.is_colliding() and !$raycasts/RayCastRight.is_colliding():
			$AnimationPlayer.play("idle")
			$SleepTimer.start()


func _on_SleepTimer_timeout():
	$AnimationPlayer.play("to_sleep")
	sleeping = true
