extends Area2D

export (NodePath) var door_
var door

#get door node
func _ready():
	door = get_node(door_)


#open
func _on_Area2D_area_entered(_area):
	if door and get_overlapping_areas().size()==1:
		door.buttons_required -=1
		$Button.frame = 0

#close
func _on_Area2D_area_exited(_area):
	if door and get_overlapping_areas().size() == 0:
		door.buttons_required +=1
		$Button.frame = 1 

#open
func _on_Area2D_body_entered(_body):
	if door and get_overlapping_bodies().size()==1:
		door.buttons_required -=1
		$Button.frame = 0

#close
func _on_Area2D_body_exited(_body):
	if door and get_overlapping_bodies().size() == 0:
		door.buttons_required +=1
		$Button.frame = 1 


#these 2 opens and 2 closes do the same thing cause for some reason it doesnt detect the box as a static object
