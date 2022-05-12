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

#puzzle variables
var selected = false


#shooter genre
var Bullet_position
onready var pistol = preload("res://scenes/entity/Pistol.tscn")
var pist_inst

#screen shake 
var screen_shake_start = false
var shake_intensity = 0

#instances
onready var Bullet = preload("res://scenes/entity/bullet.tscn")


#node references
onready var camera = $Camera

func _ready():
	Global.Player = self
	Global._Camera = camera
	$fade_out.show()
	$fade.play("fade_out")
	max_speed = export_max_speed
	deceleration = export_deceleration
	
	if GenreManager.current_genre == 0:
		Input.set_custom_mouse_cursor(null)
		$Control/shooter.hide()
		$Control/puzzle.hide()
	elif GenreManager.current_genre == 1:
		Input.set_custom_mouse_cursor(load("res://sprites/cursor_shooter.png"), Input.CURSOR_ARROW, Vector2(12,12))
		$Control/platformer.hide()
		$Control/puzzle.hide()
		pist_inst = pistol.instance()
		add_child(pist_inst)
	elif GenreManager.current_genre == 2:
		$Control/platformer.hide()
		$Control/shooter.hide()
		Input.set_custom_mouse_cursor(load("res://sprites/cursor_puzzle_1.png"), Input.CURSOR_ARROW, Vector2(12,12))

func _process(delta):
	
	if has_jumped and is_on_floor():
		has_jumped = false
		tick = false
	$platformer.text = str(Global.coll_coins)
	$shooter.text = str(Global.coll_coins)
	$puzzle.text = str(Global.coll_coins)
	
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene("res://scenes/levels/Main menu.tscn")
	
	#adjusting stuff for different genres
	if GenreManager.current_genre == 0:
		movement()
		animations()
		jump_manager()
		$shooter.hide()
		$puzzle.hide()
	elif GenreManager.current_genre == 1:
		movement_td()
		shooting()
		animations_td()
		$platformer.hide()
		$puzzle.hide()
	elif GenreManager.current_genre ==2:
		movement_td()
		drag_n_drop()
		animations_td()
		$platformer.hide()
		$shooter.hide()
	
	
	###### GRAVITY ######
	if !is_on_floor():
		if $DashTimer.is_stopped():
			velocity.y += get_gravity() * delta 
		

	
	## health manager ##
	$Control/platformer.value = Global.Health
	$Control/shooter.value = Global.Health
	$Control/puzzle.value = Global.Health
	
	
	#zooming when screen shake
	camera.zoom = lerp(camera.zoom, Vector2(1,1), 0.3)
	
	if screen_shake_start:
		camera.global_position.x += rand_range(-shake_intensity, shake_intensity) * delta
		camera.global_position.y += rand_range(-shake_intensity, shake_intensity) * delta
	



func _physics_process(_delta):
	pass
	

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
	
	#if shift is pressed I increase max speed and if its released i decrease it
	if Input.is_action_just_pressed("run"):
		max_speed += 40
		$AnimationPlayer.playback_speed = 1.1
	elif Input.is_action_just_released("run") and max_speed == export_max_speed+40:
		max_speed -= 40
		$AnimationPlayer.playback_speed = 0.8
	
	
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
	$SoundPlayer.stream = load("res://sound/Lab_Loop_Jump_v1a.wav")
	$SoundPlayer.play()



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

func animations_td():  #add animations here
	#walking
	if Input.is_action_pressed("left"):
		$AnimationPlayer.play("walk")
	elif Input.is_action_pressed("right"):
		$AnimationPlayer.play("walk")
	elif Input.is_action_pressed("up"):
		$AnimationPlayer.play("walk")
	elif Input.is_action_pressed("down"):
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	
	#sprite rotation
	if direction == -1:
		$Player.flip_h = true
	elif direction == 1:
		$Player.flip_h = false


func movement_td():
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if Input.is_action_just_pressed("left"):
		direction = -1
	elif Input.is_action_just_pressed("right"):
		direction = 1
	velocity = velocity.normalized()
	if velocity != Vector2.ZERO:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false
	
	
	velocity = move_and_slide(velocity * _speed, Vector2.UP)


func _screen_shake(intensity,time,zoom):
	if zoom:
		camera.zoom = Vector2(1,1) - Vector2(intensity * 0.003, intensity * 0.003)
	shake_intensity = intensity
	$Camera/Screen_shake_time.wait_time = time
	$Camera/Screen_shake_time.start()
	screen_shake_start = true




func shooting():
	Bullet_position = pist_inst._global_position
	if Input.is_action_just_pressed("shoot"):
		Global.instance_node(Bullet, Bullet_position, get_parent())
		randomize()
		_screen_shake(30,0.1,false)
		pist_inst.get_node("smoke").restart()
		$SoundPlayer.pitch_scale = rand_range(0.5,1.2)
		$SoundPlayer.stream = load("res://sound/LabLoop_Pistol_v2_Round_Robin_5of8_.wav")
		$SoundPlayer.play()

func drag_n_drop():
	pass

func finish():
	get_tree().change_scene("res://scenes/levels/transit_scene.tscn")
	$fade.play("fade_in")

func death():
	$fade.play("fade_in")

func _on_fade_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().reload_current_scene()


func hurt():
	$SoundPlayer.stream = load("res://sound/hurt.wav")
	$SoundPlayer.play()





func _on_Screen_shake_time_timeout():
	screen_shake_start = false
	camera.position = Vector2(0,-20)
