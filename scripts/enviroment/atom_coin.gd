extends Area2D


func _ready():
	randomize()
	$AnimatedSprite.frame = randi() %4


func _on_Area2D_body_entered(_body):
	$AudioStreamPlayer.play()
	$AnimatedSprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	Global.coll_coins +=1


func _on_AudioStreamPlayer_finished():
	queue_free()
