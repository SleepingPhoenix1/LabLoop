extends Area2D


func _ready():
	randomize()
	$AnimatedSprite.frame = randi() %4


func _on_Area2D_body_entered(body):
	queue_free()
	Global.coll_coins +=1
