extends KinematicBody2D
class_name Box

var start_position

func _ready():
	start_position = global_position
	
func push_box(velocity):
	move_and_slide(velocity, Vector2())

#if the box is no longer visible then put it back to it's initial position.
#this is so that if a player cant complete a puzzle with these boxes, they can reset the puzzle by leaving the area.
func _on_VisibilityNotifier2D_screen_exited():
	position = start_position
