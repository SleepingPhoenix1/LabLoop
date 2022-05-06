extends Node

var current_genre = 0

var current_level = 1


func _ready():
	pass

# genres are: 1-platformer;2-shooter;3-puzzle #
func change_genre_to(genre):
	current_genre = genre
