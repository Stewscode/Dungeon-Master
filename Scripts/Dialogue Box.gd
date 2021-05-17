extends CanvasLayer

# exports dialog as a variable in the inspector so that i can add a .json file with dialogue inside of it.
export(String, FILE, "*.json") var dialogue
var list_of_dialogue = []
var current_position = -1
var is_dialogue_box_in_use = false
onready var npc = get_node("/root/MainScene/NPC")

func _physics_process(delta):
	#check for ui_interact key is pressed
	if npc.is_player == true:
		if Input.is_action_just_pressed("ui_interact"):
			$NinePatchRect.visible = true
			output_dialogue()
	
	if npc.is_player == false:
		current_position = -1
		$NinePatchRect.visible = false
		

func _ready():
	print(current_position)
	#hide at start
	$NinePatchRect.visible = false



func get_dialogue():
	if is_dialogue_box_in_use == true:
		return
	$NinePatchRect.visible = true
	list_of_dialogue = load_file()
	is_dialogue_box_in_use = true
	
	output_dialogue()


func output_dialogue():
	print(current_position)
	current_position += 1
	if current_position >= len(list_of_dialogue):
		$NinePatchRect.visible = false
		is_dialogue_box_in_use = false
		return

	$NinePatchRect/Name.text = list_of_dialogue[current_position]["name"]
	$NinePatchRect/Dialogue.text = list_of_dialogue[current_position]["dialogue"]



# check if file exists and then open it and read it. return the parsed contents as text for godot to use.
func load_file():
	var file = File.new()
	if file.file_exists(dialogue):
		file.open(dialogue, file.READ)
		return parse_json(file.get_as_text())
