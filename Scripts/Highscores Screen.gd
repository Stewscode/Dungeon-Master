extends Control

var current_highscore

# Called when the node enters the scene tree for the first time.
func _ready():
	$Score.text = str(Highscore.highscore)

func _physics_process(delta):
	$Score.text = str(Highscore.highscore)
		
	

