extends StaticBody2D

export var open_by_button = false
export var buttons_required = 2
export var close_on_genre = true
export var open_on_genre = true
export var genre_number = 1 
export var starting_state = 0



func _ready():
	if starting_state == 0 and !open_by_button:
		_close()
	elif starting_state == 1:
		_open()
	if close_on_genre and genre_number == GenreManager.current_genre:
		_close()
	if open_on_genre and genre_number == GenreManager.current_genre:
		_open()


func _process(delta):
	if buttons_required <=0 and open_by_button:
		_open()
	else: _close()

func _open():
	$CollisionShape2D.disabled = true
	$TileMap.hide()

func _close():
	$CollisionShape2D.disabled = false
	$TileMap.show()


