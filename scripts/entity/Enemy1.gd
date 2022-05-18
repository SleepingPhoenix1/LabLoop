extends KinematicBody2D

export var _print = false
export(int) var SPEED: int = 50
var dir: Vector2 = Vector2.ZERO
export var health = 5

var path: Array = []	# Contains destination positions
var levelNavigation: Navigation2D = null
var player = null
var player_spotted: bool = false

onready var blood = preload("res://scenes/entity/blood.tscn")


onready var line2d = $Line2D
onready var los = $LineOFSight
onready var AnimTree = $AnimationTree
onready var AnimState = AnimTree.get("parameters/playback")

var player_direction = Vector2()
var can_shoot = false
onready var Bullet_e = load("res://scenes/entity/bullet_enemy.tscn")
onready var health_p = load("res://scenes/enviroment/health_pot.tscn")

var once = false


func _physics_process(delta):
	los.look_at(player.global_position)
	_chase()
	if los.is_colliding() and $stunned_timer.is_stopped():
		chase_target()
		if !once:
			$shoot_timer.start()
			once = true
	else: can_shoot = false





func _chase():
	var motion = dir * SPEED
	move_and_slide(motion)
	
	
	#health
	if health <= 0:
		Global.coll_coins += 3
		Global.Player._screen_shake(60,0.1,true)
		SoundManager.play_sound(load("res://sound/robot_explosion.wav"))
		var inst = blood.instance()
		get_parent().add_child(inst)
		inst.global_position = global_position
		
		
		
		if rand_range(0,6) < 1:
			var ins = health_p.instance()
			ins.global_position = global_position
			get_parent().get_parent().add_child(ins)
		queue_free()

func _ready():
	
	randomize()
	var tree = get_tree()
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	#dir = (player.position - position).normalized()
	



func chase_target():
	if los.get_collider() == player:
		dir = (player.position - position).normalized()
		can_shoot = true
	else:
		can_shoot = false
		for scent in player.scent_trail:
			if _print:
				print($scent.get_collider())
			$scent.look_at(scent.global_position)
			if $scent.get_collider() == scent.get_node("ar"):
				dir = (scent.position - position).normalized()
				los.force_raycast_update()
				
				
				if !los.get_collider() == player:
					dir = (scent.position - position).normalized()
					break
			elif $scent.get_collider() != scent.get_node("ar"): dir = Vector2.ZERO
	





func _on_Area2D_area_entered(area):
	if area.is_in_group("Bullet"):
		health -=1
		$SoundPlayer.stream = load("res://sound/hurt.wav")
		$SoundPlayer.play()
		area.explode()
		$stunned_timer.start()
		dir = -dir*0.3


func _on_shoot_timer_timeout():
	if can_shoot:
		Global.instance_node(Bullet_e, global_position, get_parent())
		$SoundPlayer.pitch_scale = rand_range(0.5,1.2)
		$SoundPlayer.stream = load("res://sound/LabLoop_Pistol_v2_Round_Robin_5of8_.wav")
		$SoundPlayer.play()

