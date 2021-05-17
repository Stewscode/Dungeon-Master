extends KinematicBody2D


# basic stats
var curHp : int = 1
var maxHp : int = 1
var moveSpeed : int = 80
var xpToGive : int = 20
var damage : int = 1
var attackRate : float = 1.0
# detection ranges
var run_away_range : int = 150
var attack_range : int = 450
var chase_range : int = 600

# smaller detection ranges so i can test to see if it wanders
#var run_away_range : int = 150
#var attack_range : int = 200
#var chase_range : int = 250

var moveDirection = 110
var movingVel = Vector2()
var facingDir = Vector2()
var velocity = Vector2()

var curAttackAnimation
var arrow
 
onready var timer = $Timer
onready var target = get_node("/root/MainScene/Player")
onready var animatedSprite = $AnimatedSprite
onready var arrow_scene = preload("res://Scenes/Objects/Arrow.tscn")
onready var random_position_generator = $"Random Position Generator"


var state = MOVE
enum {
	MOVE,
	ATTACK,
	BLOCK,
	RUN_AWAY,
	IDLE,
	WANDER
}


func _physics_process (delta):
		# checks the "state" variable and sees whether it is currently equal to MOVE, ATTACK or DODGE.
	# It then goes to whichever "state" it matches and carries out the code in there. 
	match state: # similar to switch statements
		MOVE:
			move()
		
		ATTACK:
			attack()
		
		BLOCK: # not yet implemented
			pass
			
		RUN_AWAY:
			run_away()
			
		IDLE:
			idle()
			
		WANDER:
			var direction = global_position.direction_to(random_position_generator.random_position)
			velocity = velocity.move_toward(direction * moveSpeed, 210 * delta)
			wander(direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = attackRate # set timer time to same as attack rate of the enemy
	timer.start() # start the timer


func randomize_states(list_of_states):
	list_of_states.shuffle()
	return list_of_states.pop_front()
	


func get_distance_to(target):
	var distance_to_target = position.distance_to(target.position)
	return distance_to_target


func wander(a_vector : Vector2):
	var target_position = random_position_generator.random_position # gets the player's position as a vector
	moveDirection = rad2deg(get_angle_to(target_position)) # gets the angle from this current node to the target node in radians, and then converts it to degrees (godot works in 0 to 180 and 0 to -180, instead of 0 to 360, weird).
	
	if  get_distance_to(target) > attack_range and get_distance_to(target) < chase_range:
		state = MOVE
	if random_position_generator.get_time_left() == 0:
		state = randomize_states([IDLE, WANDER])
		random_position_generator.set_timer(rand_range(1, 3))
		
		
	if a_vector.x > 0:
		movingVel.x = 1
		facingDir = Vector2(1, 0)
			
	if a_vector.x < 0:
		movingVel.x = -1
		facingDir = Vector2(-1, 0)

	if a_vector.y < 0:
		movingVel.y = -1
		facingDir = Vector2(0, -1)

	if a_vector.y > 1:
		movingVel.y = 1
		facingDir = Vector2(0, 1)
	
	if global_position.distance_to(random_position_generator.random_position) <= 5:
		state = randomize_states([IDLE, WANDER])
		random_position_generator.set_timer(rand_range(1, 3))
		
	move_and_slide(velocity)
	manage_animations()


# take an animation and play that animation.
func play_animation (anim_name):
	if animatedSprite.animation != anim_name: # if the same animation is not currently playing
		animatedSprite.play(anim_name) # plays animation


# function to manage the seperate attack animations
func manage_attack_animations():
	if state == ATTACK:
		if facingDir.x == 1:
			curAttackAnimation = "AttackRight" # set's current animation to the appropriate animation
			play_animation(curAttackAnimation) # plays said animation
	
		if facingDir.x == -1:
			curAttackAnimation = "AttackLeft"
			play_animation(curAttackAnimation)
	
		if facingDir.y == -1:
			curAttackAnimation = "AttackUp"
			play_animation(curAttackAnimation)

		if facingDir.y == 1:
			curAttackAnimation = "AttackDown"
			play_animation(curAttackAnimation)
				
		if !facingDir.x == 1 && !facingDir.x == -1 && !facingDir.y == 1 && !facingDir.y == -1:
			curAttackAnimation = "AttackDown"
			play_animation(curAttackAnimation)


# function which checks the current velocity and plays an animation depending on that.
# if the velocity is 0, it will chack what direction the character is facing and play an
# animation depending on that.
func manage_animations ():
	if movingVel.x > 0:
		play_animation("MoveRight")
	elif movingVel.x < 0:
		play_animation("MoveLeft")
	elif movingVel.y < 0:
		play_animation("MoveUp")
	elif movingVel.y > 0:
		play_animation("MoveDown")
	elif movingVel.x == 0 && movingVel.y == 0:
		if facingDir.x == 1:
			play_animation("IdleRight")
			
		elif facingDir.x == -1:
			play_animation("IdleLeft")
			
		elif facingDir.y == -1:
			play_animation("IdleUp")
			
		elif facingDir.y == 1:
			play_animation("IdleDown")
			



# function which allows an enemy to take damage
# pass in amount of damage to be taken
func take_damage (dmgToTake): 
	curHp -= dmgToTake # takes away damage taken from hp pool
	if curHp <= 0: # if the enemy's hp drops to 0 then it will "die".
		die() # call die() function
 
# function to let enemy do things once it loses all its HP, eg die.
func die ():
	Highscore.add_to_score()
	target.give_xp(xpToGive) # function to give XP to player .
	queue_free() # deletes the node - making it disappear and essentially die.


func move():
	movingVel = Vector2()
	var distanceToTarget = position.distance_to(target.position)
	
	# if the target is between the attack range and the run away range then attack
	if distanceToTarget <= attack_range  &&  distanceToTarget > run_away_range: # if the target is within the attack range :
		state = ATTACK
	# if the target is in the run away range then run away
	if distanceToTarget <= run_away_range: 
		state = RUN_AWAY
	# if outside of attack range but inside of chase range... chase them
	if distanceToTarget > attack_range and distanceToTarget < chase_range:
		var vel = (target.position - position).normalized()
		move_and_slide(vel * moveSpeed) # let enemy move
	
	var player = target.position # gets the player's position as a vector
	moveDirection = rad2deg(get_angle_to(player)) # gets the angle from this current node to the player node in radians and convert it to degrees (godot work in 0 to 180 and 0 to -180, instead of 0 to 360, weird).
	
	if moveDirection > -135 and moveDirection < -45:
		movingVel.y = -1
		facingDir = Vector2(0, -1)
	if moveDirection > 45 and moveDirection < 135:
		movingVel.y = 1
		facingDir = Vector2(0, 1)
	if moveDirection < -135 or moveDirection > 135:
		movingVel.x = -1
		facingDir = Vector2(-1, 0)
	if moveDirection > -45 and moveDirection < 45:
		movingVel.x = 1
		facingDir = Vector2(1, 0)
	# if target is out of enemy's chase radius then stop	
	if distanceToTarget > chase_range:
		state = randomize_states([IDLE, WANDER])
	
	manage_animations()


func testmove():
	movingVel = Vector2()
	var distanceToTarget = position.distance_to(target.position)
	
	var vel = (target.position - position).normalized()
	move_and_slide(vel * moveSpeed) # let enemy move
	
	var player = target.position # gets the player's position as a vector
	moveDirection = rad2deg(get_angle_to(player)) # gets the angle from this current node to the player node in radians and convert it to degrees (godot work in 0 to 180 and 0 to -180, instead of 0 to 360, weird).
	
	# if facing up
	if moveDirection > -135 and moveDirection < -45:
		movingVel.y = -1
		facingDir = Vector2(0, -1)
	# if facing down
	if moveDirection > 45 and moveDirection < 135:
		movingVel.y = 1
		facingDir = Vector2(0, 1)
	# if facing left
	if moveDirection < -135 or moveDirection > 135:
		movingVel.x = -1
		facingDir = Vector2(-1, 0)
	# if facing right
	if moveDirection > -45 and moveDirection < 45:
		movingVel.x = 1
		facingDir = Vector2(1, 0)
	# if target is out of enemy's chase radius then stop	
	
	manage_animations()
	
	

func stop_moving():
	movingVel.x = 0
	movingVel.y = 0
	manage_animations()
	

func attack():
	var distanceToTarget = position.distance_to(target.position)
	# if the target is between the attack range and the run away range then attack
	if distanceToTarget <= attack_range  &&  distanceToTarget > run_away_range: # if the target is within the attack range :
		state = ATTACK
	# if the target is in the run away range then run away
	if distanceToTarget <= run_away_range: 
		state = RUN_AWAY
	# if outside of attack range but inside of chase range... chase them
	if distanceToTarget > attack_range and distanceToTarget < chase_range:
		state = MOVE


func shoot_arrow():
	stop_moving()
	
	var player = target.position
	moveDirection = rad2deg(get_angle_to(player))
	
	arrow = arrow_scene.instance()
	arrow.set_rotation((target.position - global_position).angle())
	
	# if facing up
	if moveDirection > -135 and moveDirection < -45:
		arrow.global_position = get_node("Shooting Positions/Shoot Up").global_position
		facingDir = Vector2(0, -1)
		
	# if facing down
	if moveDirection > 45 and moveDirection < 135:
		arrow.global_position = get_node("Shooting Positions/Shoot Down").global_position
		facingDir = Vector2(0, 1)
		
	# if facing left
	if moveDirection < -135 or moveDirection > 135:
		arrow.global_position = get_node("Shooting Positions/Shoot Left").global_position
		facingDir = Vector2(-1, 0)
		
	# if facing right
	if moveDirection > -45 and moveDirection < 45:
		facingDir = Vector2(1, 0)
		arrow.global_position = get_node("Shooting Positions/Shoot Right").global_position
	
	arrow.target = target
	get_parent().add_child(arrow)
	$Timer.set_wait_time(1)
	
	manage_animations()


func run_away():
	movingVel = Vector2()
	var distanceToTarget = position.distance_to(target.position)
	
	var velocity = (position - target.position).normalized()
	move_and_slide(velocity * moveSpeed) # let enemy move
	
	if distanceToTarget <= run_away_range: 
		var vel = (target.position - position).normalized()
		move_and_slide(-vel * moveSpeed) # let enemy move
		
		var player = target.position # gets the player's position as a vector
		moveDirection = -(rad2deg(get_angle_to(player)))
	
		# if facing up
		if moveDirection > -135 and moveDirection < -45:
			movingVel.y = -1
			facingDir = Vector2(0, -1)
		# if facing down
		if moveDirection > 45 and moveDirection < 135:
			movingVel.y = 1
			facingDir = Vector2(0, 1)
		# if facing left
		if moveDirection < -135 or moveDirection > 135:
			movingVel.x = 1
			facingDir = Vector2(-1, 0)
		# if facing right
		if moveDirection > -45 and moveDirection < 45:
			movingVel.x = -1
			facingDir = Vector2(1, 0)
		# finally manage the animations
		manage_animations()
		
	# if the target is between the attack range and the run away range then attack
	elif distanceToTarget <= attack_range  &&  distanceToTarget > run_away_range: # if the target is within the attack range :
		state = ATTACK
	# if outside of attack range but inside of chase range... chase them
	elif distanceToTarget > attack_range and distanceToTarget < chase_range:
		state = MOVE
		
	


func idle():
	movingVel.x = 0
	movingVel.y = 0
	
	# if target is outside attack range and inside chase range:
	if  get_distance_to(target) > attack_range and get_distance_to(target) < chase_range:
		state = MOVE
	
	if random_position_generator.get_time_left() == 0:
		state = randomize_states([IDLE, WANDER])
		random_position_generator.set_timer(rand_range(1, 3))
		
	manage_animations()

 
func _on_Timer_timeout():
	if state == ATTACK:
		shoot_arrow()
	manage_attack_animations()
	

