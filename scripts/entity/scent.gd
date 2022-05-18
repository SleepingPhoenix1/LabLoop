extends Node2D


func _ready():
	$Timer.connect("timeout", self, "remove_scent")

func remove_scent():
	Global.Player.scent_trail.erase(self)
	queue_free()
