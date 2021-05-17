extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Score.text = str(Highscore.score)

func _physics_process(delta):
	$Score.text = str(Highscore.score)
		
