extends CanvasLayer

func _ready():
	$TextureRect.visible = false
	$"Continue Button".visible = false
	$"Menu Button".visible = false

func _physics_process(delta):
	if get_tree().get_current_scene().get_name() != "MainScene":
		$TextureRect.visible = false
		$"Continue Button".visible = false
		$"Menu Button".visible = false
		get_tree().paused = false
	
#https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
# pause and unpause the entire tree upon pressing the pause button.
#node set to process so it doesn't pause
func _input(event):
	if get_tree().get_current_scene().get_name() == "MainScene":
		if event.is_action_pressed("ui_pause"):
			get_tree().paused = !get_tree().paused
			$TextureRect.visible = !$TextureRect.visible #provide visual feedback by making the screen darker (loading a slightly transparent, black background)
			$"Continue Button".visible = !$"Continue Button".visible
			$"Menu Button".visible = !$"Menu Button".visible


#if continue button pressed, unpause and make the background not visible
func _on_Continue_Button_pressed():
	get_tree().paused = false
	$TextureRect.visible = false
	$"Continue Button".visible = false
	$"Menu Button".visible = false
