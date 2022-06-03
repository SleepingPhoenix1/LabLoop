extends Node

var Player = null
var _Camera = null
var Health = 10
var selected = false
var hit_bullet = null

var coll_coins = 0

func instance_node(node, location, parent):
	var node_inst = node.instance()
	parent.add_child(node_inst)
	node_inst.global_position = location
	return node_inst

func hurt(stunt):
	Player.hurt()
	if stunt:
		Player.stunt(hit_bullet)
		hit_bullet = null

func _process(_delta):
	if Health <= 0:
		coll_coins -= 15
		Player.death()
		Health = 10
	
	if Health > 10:
		Health = 10
