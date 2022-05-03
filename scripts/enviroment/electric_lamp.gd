extends StaticBody2D

onready var charge = load("res://scenes/entity/electric_charge.tscn")

func _ready():
	pass


func _on_Spawn_rate_timeout():
	Global.instance_node(charge, global_position, get_parent())
