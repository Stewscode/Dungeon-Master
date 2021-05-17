extends Area2D

onready var target = get_node("/root/MainScene/Player")
onready var user_interface = get_node("/root/MainScene/CanvasLayer/UI")
#onready var dialogue_box = get_node("/root/MainScene/NPC/Dialogue Box")
var is_player = false
onready var dialogue_box = $"Dialogue Box"
onready var dialogue_box_2 = $"Dialogue Box 2"

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if is_player == true:
		if Input.is_action_just_pressed("ui_interact"):
			if target.gold >= 5 and singleton_script.key_obtained == false:
				singleton_script.is_enough_gold = true
				open_dialogue_2()
				target.gold -= 5
				target.userInterface.update_gold(target.gold)
				singleton_script.key_obtained = true
				
			elif target.gold < 5 and singleton_script.key_obtained == false:
				open_dialogue()
		

func open_dialogue():
	if dialogue_box != null:
		dialogue_box.get_dialogue()


func open_dialogue_2():
	if dialogue_box_2 != null:
		dialogue_box_2.get_dialogue()


func _on_NPC_body_entered(body):
	if body == target:
		
		is_player = true
		print("is_player : ",is_player)


func _on_NPC_body_exited(body):
	if body == target:
		
		is_player = false
		print("is_player : ", is_player)
