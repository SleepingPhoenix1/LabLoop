extends KinematicBody2D

export(int) var SPEED: int = 40
var velocity: Vector2 = Vector2.ZERO
export var health = 5

var path: Array = []	# Contains destination positions
var levelNavigation: Navigation2D = null
var player = null
var player_spotted: bool = false

onready var line2d = $Line2D
onready var los = $LineOFSight
onready var AnimTree = $AnimationTree
onready var AnimState = AnimTree.get("parameters/playback")

var player_direction = Vector2()
var can_shoot = false
onready var Bullet_e = load("res://scenes/entity/bullet_enemy.tscn")
onready var health_p = load("res://scenes/enviroment/health_pot.tscn")



func _ready():
	randomize()
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		player = tree.get_nodes_in_group("Player")[0]

func _physics_process(_delta):
	line2d.global_position = Vector2.ZERO
	if player:
		los.look_at(player.global_position)
		player_direction = Vector2(sign(player.global_position.x - global_position.x), sign(player.global_position.y - global_position.y))
		check_player_in_detection()
		if player_spotted:
			generate_path()
			navigate()
	move()
	
	#health
	if health <= 0:
		Global.coll_coins += 3
		if rand_range(0,6) < 1:
			var ins = health_p.instance()
			ins.global_position = global_position
			get_parent().get_parent().add_child(ins)
		queue_free()

func check_player_in_detection():
	var collider = los.get_collider()
	if collider and collider.is_in_group("Player"):
		player_spotted = true
		can_shoot = true
	else: 
		player_spotted = false
		path = []
		velocity = Vector2.ZERO
		can_shoot = false

func navigate():	# Define the next position to go to
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * SPEED
		
		# If reached the destination, remove this point from path array
		if global_position == path[0]:
			path.pop_front()

func generate_path():	# It's obvious
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)

func move():
	if velocity != Vector2.ZERO:
		AnimTree.set("parameters/idle/blend_position", velocity)
		AnimTree.set("parameters/walk/blend_position", velocity)
		AnimState.travel("walk")
	else:
		AnimState.travel("idle")
	velocity = move_and_slide(velocity)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Bullet"):
		health -=1
		$SoundPlayer.stream = load("res://sound/hurt.wav")
		$SoundPlayer.play()
		area.explode()


func _on_shoot_timer_timeout():
	if can_shoot:
		Global.instance_node(Bullet_e, global_position, get_parent())
		$SoundPlayer.pitch_scale = rand_range(0.5,1.2)
		$SoundPlayer.stream = load("res://sound/LabLoop_Pistol_v2_Round_Robin_5of8_.wav")
		$SoundPlayer.play()

