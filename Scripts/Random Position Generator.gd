extends Node2D

export(int) var a_range = 1000

onready var initial_position = global_position
onready var random_position = global_position

onready var timer = $Timer

func _ready():
	new_random_position()

func new_random_position():
	var random_vector = Vector2(rand_range(-a_range, a_range ), rand_range(-a_range, a_range))
	random_position = initial_position + random_vector


func set_timer(time):
	timer.start(time)


func get_time_left():
	return timer.time_left
	

func _on_Timer_timeout():
	new_random_position()
