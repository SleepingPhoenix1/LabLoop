extends AudioStreamPlayer


func _ready():
	pass

func play_music(id):
	if id == 0:
		stream = preload("res://sound/Labloop_Platformer_v1.mp3")
		play()
	elif id == 1:
		stream = preload("res://sound/Lab_Loop_Shooter_v2_Loopable.mp3")
		play()
	elif id == 2:
		stream = preload("res://sound/Labloop_Puzzle_v1.mp3")
		play()
	elif id == 3:
		stop()

func play_sound(sound):
	$SomeAudioPlayer.stream = sound
	$SomeAudioPlayer.play()
