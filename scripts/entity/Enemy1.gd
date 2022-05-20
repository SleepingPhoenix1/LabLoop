extends KinematicBody2D

export var _print = false
export(int) var SPEED: int = 55
var dir: Vector2 = Vector2.ZERO
export var health = 4

var path: Array = []	# Contains destination positions
var levelNavigation: Navigation2D = null
var player = null
var player_spotted: bool = false

onready var blood = preload("res://scenes/entity/blood.tscn")


onready var line2d = $Line2D
onready var los = $LineOFSight

var player_direction = Vector2()
var can_shoot = false
onready var Bullet_e = load("res://scenes/entity/bullet_enemy.tscn")
onready var health_p = load("res://scenes/enviroment/health_pot.tscn")

var once = false
var once2 = false

func _physics_process(delta):
	$Node2D.player_visible = player_spotted
	los.look_at(player.global_position)
	_chase()
	if los.is_colliding() and $stunned_timer.is_stopped():
		chase_target()
		if !once:
			$shoot_timer.start()
			once = true
	else: 
		can_shoot = false


func _calm():
	$AnimationPlayer.play("idle_calm")


func _chase():
	if dir == Vector2.ZERO and $AnimationPlayer.current_animation != "idle_calm":
		$AnimationPlayer.play("idle_attack")
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
	$AnimationPlayer.play("idle_calm")
	randomize()
	var tree = get_tree()
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]
	#dir = (player.position - position).normalized()
	$Node2D.enemy = self



func chase_target():
	#if _print:
	#	print($AnimationPlayer.current_animation)
	if los.get_collider() == player:
		player_spotted = true
		once2 = false
		$AnimationPlayer.play("walk")
		$Enemy1.scale.x = sign(player.global_position.x-global_position.x)
		dir = (player.position - position).normalized()
		can_shoot = true
	else:
		player_spotted = false
		can_shoot = false
		for scent in player.scent_trail:
			$scent.look_at(scent.global_position)
			if $scent.get_collider() == scent.get_node("ar"):
				$AnimationPlayer.play("walk")
				$Enemy1.scale.x = sign(scent.global_position.x-global_position.x)
				dir = (scent.position - position).normalized()
				los.force_raycast_update()
				
				
				if !los.get_collider() == player:
					$AnimationPlayer.play("walk")
					$Enemy1.scale.x = sign(scent.global_position.x-global_position.x)
					dir = (scent.position - position).normalized()
					$Enemy1.scale.x = sign(player.global_position.x-global_position.x)
					player_spotted = true
					break
			elif $scent.get_collider() != scent.get_node("ar"): 
				dir = Vector2.ZERO
				
	





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
		Global.instance_node(Bullet_e, $Node2D._global_position, get_parent())
		$SoundPlayer.pitch_scale = rand_range(0.5,1.2)
		$SoundPlayer.stream = load("res://sound/LabLoop_Pistol_v2_Round_Robin_5of8_.wav")
		$SoundPlayer.play()




