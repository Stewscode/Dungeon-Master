extends CanvasLayer

# exports dialog as a variable in the inspector so that i can add a .json file with dialogue inside of it.
export(String, FILE, "*.json") var dialogue
var list_of_dialogue = []
var current_position = 0

onready var npc = get_node("/root/MainScene/NPC")

func _physics_process(delta):
	#check for ui_interact key is pressed
	if npc.is_player == true and singleton_script.is_enough_gold == true:
		$NinePatchRect.visible = true
	if npc.is_player == false:
		$NinePatchRect.visible = false
		current_position = -1
		
	if Input.is_action_just_pressed("ui_interact"):
		next_dialogue()


func _ready():
	$NinePatchRect.visible = false
	get_dialogue()



func get_dialogue():
	$NinePatchRect.visible = true
	list_of_dialogue = load_file()
	print(list_of_dialogue[0]["name"])
	print(list_of_dialogue[0]["dialogue"])
	
	current_position = -1
	next_dialogue()


func next_dialogue():
	current_position += 1
	if current_position >= len(list_of_dialogue):
		$NinePatchRect.visible = false
		return
	$NinePatchRect/Name.text = list_of_dialogue[current_position]["name"]
	$NinePatchRect/Dialogue.text = list_of_dialogue[current_position]["dialogue"]



# check if file exists and then open it and read it. return the parsed contents as text for godot to use.
func load_file():
	var file = File.new()
	if file.file_exists(dialogue):
		file.open(dialogue, file.READ)
		return parse_json(file.get_as_text())
