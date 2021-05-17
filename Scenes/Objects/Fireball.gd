extends Area2D


var move = Vector2.ZERO
var speed = 4
var direction_to_player = Vector2.ZERO
var target = null
var damage = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	direction_to_player = target.position - global_position


func _physics_process(delta):
	move = Vector2.ZERO
	
	move = move.move_toward(direction_to_player, delta)
	move = move.normalized() * speed
	position += move

# When the arrow gets shot off the screen, the node is deleted to not use up too many resources.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass


func _on_Fireball_body_entered(body):
	if body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage(damage)
			print("body has taken ", damage, " damage")
			queue_free()
