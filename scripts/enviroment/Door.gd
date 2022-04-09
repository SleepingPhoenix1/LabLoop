extends StaticBody2D

export var buttons_required = 2
export var close_on_genre = true
export var open_on_genre = true
export var genre_number = 1 
export var starting_state = 0




func _ready():
	if starting_state == 0:
		_close()
	elif starting_state == 1:
		_open()
	if close_on_genre and genre_number == GenreManager.current_genre:
		_close()
	if open_on_genre and genre_number == GenreManager.current_genre:
		_open()


func _process(delta):
	if buttons_required <=0:
		_open()
	

func _open():
	$CollisionShape2D.disabled = true
	$TileMap.hide()

func _close():
	$CollisionShape2D.disabled = false
	$TileMap.show()
