extends Area2D

export (NodePath) var door_
var door
func _ready():
	door = get_node(door_)


func _on_Area2D_area_entered(_area):
	if door and get_overlapping_areas().size()==1:
		door.buttons_required -=1


func _on_Area2D_area_exited(_area):
	if door and get_overlapping_areas().size() == 0:
		door.buttons_required +=1


func _on_Area2D_body_entered(_body):
	if door and get_overlapping_bodies().size()==1:
		door.buttons_required -=1


func _on_Area2D_body_exited(_body):
	if door and get_overlapping_bodies().size() == 0:
		door.buttons_required +=1
