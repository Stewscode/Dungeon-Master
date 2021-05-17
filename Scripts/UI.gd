extends Control


# Declare member variables here:

# Variables to reference nodes in the scene
onready var healthBar : TextureProgress = get_node("Background/HealthBar")
onready var experienceBar : TextureProgress = get_node("Background/ExperienceBar")
onready var staminaBar : TextureProgress = get_node("Background/StaminaBar")
onready var playerGoldLabel : Label = get_node("Background/PlayerGoldLabel")
onready var playerLevelLabel : Label = get_node("Background/PlayerLevelLabel")
onready var ExpBar : ProgressBar = get_node("Background/ExpBar")
onready var score_label : Label = get_node("Background/ScoreLabel")

func _process(delta):
	update_score()

func intitialise(): 
	playerLevelLabel.text = ""
	
# updates the level text Label node
func update_level(curLevel):
#	var test = ""
#	test = str(level)
#	print(test)
#	playerLevelLabel.text = test # sets the text of the player level label to the passed in string 
	playerLevelLabel.text = str(curLevel)
 
# updates the health bar values to visualise how much hp is left
func update_health(curHp, maxHp):
	# this calculation will always show the correct ratio no matter how high max and cur HP goes
	healthBar.value = (100 / maxHp) * curHp 

 
# updates the xp bar values to visualise how much xp is needed till the next level
func update_experience (curXp, xpToLevelUp):
	# this calculation will always show the correct ratio no matter how high required and cur XP goes
	ExpBar.max_value = xpToLevelUp
	ExpBar.value = curXp

 

func update_stamina(curStamina, maxStamina):
	staminaBar.value = (100 / maxStamina) * curStamina


# updates the player gold label to show current gold
func update_gold (gold):
	playerGoldLabel.text = "Gold: " + str(gold)


func update_score():
	score_label.text = "Score: " + str(Highscore.score)
	


