extends Area2D

var picked_up = false

#randomizes the 1st sprite
func _ready():
	randomize()
	$AnimatedSprite.frame = randi() %4

#pick up
func _on_Area2D_body_entered(_body):
	$AudioStreamPlayer.play()
	$AnimatedSprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	Global.coll_coins +=1
	$Particle.emitting = true
	picked_up = true

func _process(delta):
	#when animation is finished delete the coin
	if picked_up and !$Particle.emitting:
		queue_free()
