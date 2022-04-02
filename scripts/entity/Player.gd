extends KinematicBody2D


###### PLATFORMER #######
export var speed_pl = 20
export var max_speed_pl = 150
export var jump = -500
export var gravity_pl = 30

var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	if GenreManager.current_genre == 0:
		movement_pl()
		gravity()
	elif GenreManager.current_genre == 1:
		movement_td()

func _process(delta):
	pass


func movement_pl():
	#setting the speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed_pl
	elif Input.is_action_pressed("right"):
		velocity.x += speed_pl
	else: velocity.x = 0
	velocity.x = clamp(velocity.x, -max_speed_pl, max_speed_pl)
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y +=jump
	
	move_and_slide(velocity,Vector2.UP)

func gravity():
	if !is_on_floor():
		velocity.y += gravity_pl
		velocity.y =clamp(velocity.y, -100000000, 1000)
	else: velocity.y = 1

func movement_td():
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = velocity.normalized()
	
	move_and_slide(velocity * 120, Vector2.UP)
