extends KinematicBody2D

var landing = false
var tick = false
var current_speed = 0
var is_moving = false

var direction = 1
var main_dir = 1
var dash_direction = Vector2(1,0)
var can_move = true

export var acceleration = 10
export var export_deceleration = 20
var deceleration = 15

export var export_max_speed = 120
var max_speed = 100
export var turning_speed = 50

var velocity = Vector2()
#jumping variables
export var jump_slowing_down = 3

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float
export var lowfallMultiplier = 1
var jump_buffer = false

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
#falling variables
export var maxfallspeed = 200
var has_pressed_jump = false
var has_jumped = false
export var slower_fall_mult = 20


# top down movement variables
var _acceleration = 20
var _max_speed =120
var _speed = 120

#shooter genre
var Bullet_position
onready var AnimTree = $AnimationTree
onready var AnimState = AnimTree.get("parameters/playback")

#instances
onready var Bullet = preload("res://scenes/entity/bullet.tscn")

func _ready():
	max_speed = export_max_speed
	deceleration = export_deceleration

func _process(delta):
	shooting()
	Global.Player = self
	if has_jumped and is_on_floor():
		max_speed = export_max_speed
		has_jumped = false
		tick = false
	$RichTextLabel.text = str(Global.coll_coins)
	
	###### GRAVITY ######
	if !is_on_floor():
		if $DashTimer.is_stopped():
			velocity.y += get_gravity() * delta 
		
		#### SLOWING DOWN IN AIR ####
		if has_jumped and !tick:
			max_speed -= jump_slowing_down
			tick = true
			has_pressed_jump = false
		

	
	



func _physics_process(_delta):
	if GenreManager.current_genre == 0:
		movement()
		animations()
		jump_manager()
		$PlayerAShoot.hide()
		$AnimationTree.active = false
		$Player.show()
	elif GenreManager.current_genre == 1:
		movement_td()
	#print(has_jumped)
	

func jump_manager():
	###### JUMP BUFFERING ######
	if $jumpBuffer.is_colliding() and Input.is_action_just_pressed("jump") and velocity.y > 0:
		jump_buffer = true
	
	######## JUMPING ##########
	if Input.is_action_just_pressed("jump") or (is_on_floor() and jump_buffer):
		has_pressed_jump = true
		if is_on_floor() or !$"Coyote timer".is_stopped():
			jump()
			#$SoundPlayer.stream = preload("res://soundeffects/jump.ogg")
			#$SoundPlayer.play()
			$"Coyote timer".stop()
	
	###### LOWER JUMPING ######
	if has_jumped and Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y += lowfallMultiplier


func movement():
	##### ACCELERATION #####
	if is_moving and can_move:
		acceleration()
	
	##### MOVEMENT #####
	if Input.is_action_pressed("left"):
		is_moving = true
		if !Input.is_action_pressed("right") and main_dir == -1:
			direction = -1
		elif Input.is_action_pressed("right") and main_dir == -1:
			direction = 1
		if Input.is_action_pressed("left") and Input.is_action_just_released("right") and main_dir == 1:
			main_dir = -1
		if Input.is_action_just_pressed("left") and !Input.is_action_pressed("right"):
			main_dir = -1
		#print("l")
	if Input.is_action_pressed("right"):
		#print("r")
		is_moving = true
		if !Input.is_action_pressed("left") and main_dir == 1:
			direction = 1
		elif Input.is_action_pressed("left") and main_dir == 1:
			direction = -1
		if Input.is_action_pressed("right") and Input.is_action_just_released("left") and main_dir == -1:
			main_dir = 1
		if Input.is_action_just_pressed("right") and !Input.is_action_pressed("left"):
			main_dir = 1
	
	
	
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("right"): 
		is_moving = false
		deceleration()
	
	if velocity.x != 0 and !has_jumped:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false
	
	
	
	
	##### COYOTE TIMER #####
	var was_on_floor = is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if !is_on_floor() and was_on_floor and !has_jumped and velocity.y > 0:
		$"Coyote timer".start()
	
	
	workarounds()
	
	


# warning-ignore:function_conflicts_variable
func acceleration():
	if velocity.x < max_speed and direction == 1:
		velocity.x += acceleration #/ 2
	elif velocity.x > -max_speed and direction == -1:
		velocity.x -= acceleration #/ 2
	else:
		if $DashTimer.is_stopped():
			velocity.x = max_speed * sign(velocity.x)
# warning-ignore:function_conflicts_variable
func deceleration():
	if velocity.x > 0 and direction == 1:
		velocity.x -= deceleration
	elif velocity.x < 0 and direction == -1:
		velocity.x += deceleration
	else: velocity.x = 0


func get_gravity() -> float:  #sets gravity type
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump(): #jumping
	velocity.y = jump_velocity
	jump_buffer = false



func workarounds():
		#max falling speed
	if velocity.y > maxfallspeed:
		velocity.y = maxfallspeed
	
	#stops y velocity if you hit ceiling
	if is_on_ceiling():
		velocity.y = 0
	
	#removes y velocity when on ground
	if is_on_floor():
		velocity.y = 1
		$DashDisableMove.stop()
	
	#removes x velocity if colliding with a wall
	if is_on_wall():
		velocity.x = 0
	
	
	if !is_on_floor() and has_pressed_jump:
		has_jumped = true
	






func animations():  #add animations here
	#walking
	if Input.is_action_pressed("left") and is_on_floor():
		$AnimationPlayer.play("walk")
	elif Input.is_action_pressed("right") and is_on_floor():
		$AnimationPlayer.play("walk")
	elif is_on_floor() and velocity.x == 0: 
		$AnimationPlayer.play("idle")
		
	
	#sprite rotation
	if direction == -1:
		$Player.flip_h = true
	elif direction == 1:
		$Player.flip_h = false
	#jumping
	if has_jumped and velocity.y < 0:
		$AnimationPlayer.play("jump")
		#$"Scale manager".play("jump")
		landing = true
	
	#start falling
	if velocity.y > 1 and !is_on_floor():
		$AnimationPlayer.play("fall")
		$"Scale manager".play("fall")
		landing = true
	
	
	if is_on_floor() and landing:
		$"Scale manager".play("land")
		landing = false

func movement_td():
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = velocity.normalized()
	if velocity != Vector2.ZERO:
		$Particles2D.emitting = true
		AnimTree.set("parameters/idle/blend_position", velocity)
		AnimTree.set("parameters/walk/blend_position", velocity)
		AnimState.travel("walk")
	else:
		AnimState.travel("idle")
		$Particles2D.emitting = false
	
	
	move_and_slide(velocity * _speed, Vector2.UP)


func shooting():
	Bullet_position = $Position2D.global_position
	if Input.is_action_just_pressed("shoot") and GenreManager.current_genre == 1:
		Global.instance_node(Bullet, Bullet_position, get_parent())



