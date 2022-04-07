extends Node

var Player = null
var Health = 10

var coll_coins = 0

func instance_node(node, location, parent):
	var node_inst = node.instance()
	parent.add_child(node_inst)
	node_inst.global_position = location
	return node_inst


func _process(delta):
	if Health <= 0:
		get_tree().reload_current_scene()
		Health = 10
