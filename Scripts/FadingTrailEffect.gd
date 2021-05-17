# This "Fading Trail Effect" is used to visually show that the character is going fast when "dodging". It adds on top of the dodging animation
# It slowly changes the colour of the sprite to transparent over time and then frees up the queue.
extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	# interpolate_propety is the properties of the tween, apply it to itself, change the propert "modulate", give it an initial value,
	# give it a value to go to (put the last number as 0 to make it transparent), set time it takes to do something, 
	# give it an easing property, tell it to ease out.
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0.5), Color(1,1,1,0), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	# start the tween
	$Tween.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Once finished tweening, frees up the deletes the node which has finished tweening.
func _on_Tween_tween_completed(object, key):
	queue_free()
