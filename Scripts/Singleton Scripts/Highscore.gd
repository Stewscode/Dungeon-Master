extends Node

var score = 0
var highscore = 0
const filepath = "res://highscore file.txt"

func add_to_score():
	score += 100
	print(score)

func _ready():
	load_highscore()
	
func _physics_process(delta):
	set_highscore(score)
	#load_highscore()


func load_highscore():
	var file = File.new()
	if file.file_exists(filepath) != true:
		return
		
	file.open(filepath, File.READ)
	highscore = file.get_var()
	file.close()


func save_highscore():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(highscore)
	file.close()


func set_highscore(score):
	if score > highscore:
		highscore = score
		save_highscore()
