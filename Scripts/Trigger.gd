extends Area2D


onready var box = get_node("root/MainScene/Box")
onready var box2 = get_node("root/MainScene/Box2")

func _on_Trigger_for_a_box_body_entered(body):
	if body.name == "Box" or body.name == "Box2":
		if singleton_script.trigger1_activated == false:
			singleton_script.trigger1_activated = true
			move_to_center(body)
			body.start_position = global_position
			get_tree().queue_delete(self)
			print("Box collided with trigger")
		elif singleton_script.trigger2_activated == false:
			singleton_script.trigger2_activated = true
			move_to_center(body)
			body.start_position = global_position
			get_tree().queue_delete(self)

func move_to_center(body):
	if body == box or body == box2:
		body.position = global_position
