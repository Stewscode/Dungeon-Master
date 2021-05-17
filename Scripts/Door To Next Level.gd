extends Sprite

onready var target = get_node("/root/MainScene/Player")

func _on_Door_body_entered(body):
	if body == target:
		if int(get_tree().current_scene.filename) == 2:
			if singleton_script.trigger1_activated == true and singleton_script.trigger2_activated == true:
				singleton_script.trigger1_activated = false
				singleton_script.trigger2_activated = false
				get_tree().change_scene("res://Scenes/Levels/Level " + str(int(get_tree().current_scene.filename) + 1) + ".tscn")

		if singleton_script.key_obtained == true:
				singleton_script.key_obtained = false
				get_tree().change_scene("res://Scenes/Levels/Level " + str(int(get_tree().current_scene.filename) + 1) + ".tscn")
		
