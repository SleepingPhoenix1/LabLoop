extends Area2D


func _ready():
	pass


func _on_Lazer_body_entered(_body):
	Global.Health = 0
	Global.hurt(false)
