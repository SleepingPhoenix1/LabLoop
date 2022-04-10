extends Area2D


func _ready():
	pass


func _on_Lazer_body_entered(body):
	Global.Health = 0
