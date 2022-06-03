extends StaticBody2D

export var open_by_button = false
export var buttons_required = 2
export var close_on_genre = true
export var close_on_genre2 = false
export var open_on_genre = true
export var genre_number = 1 
export var genre_number2 = 2
export var starting_state = 0
export var _print = false


var close = false

func _ready():
	#if starting state is 0 then close on start else open
	if starting_state == 0:
		_close()
		close = true
	elif starting_state == 1:
		_open()
	
	#if close on genre and current genre is equal to it then close
	if close_on_genre and genre_number == GenreManager.current_genre:
		_close()
		close = true
	#if you need to close it for 2 genres
	if close_on_genre2 and genre_number2 == GenreManager.current_genre:
		_close()
		close = true
	
	if open_on_genre and genre_number == GenreManager.current_genre:
		_open()


func _process(_delta):
	if _print:
		print(buttons_required)
	if buttons_required <=0 and open_by_button:
		_open()
	else: 
		if open_by_button and close:
			_close()

func _open():
	$CollisionShape2D.disabled = true
	$TileMap.hide()

func _close():
	$CollisionShape2D.disabled = false
	$TileMap.show()


