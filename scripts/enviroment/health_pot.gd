extends Area2D


func _ready():
	pass


func _on_Area2D_body_entered(_body):
	Global.Health += 3
	queue_free()
