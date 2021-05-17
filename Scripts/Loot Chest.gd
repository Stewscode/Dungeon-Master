extends StaticBody2D

export var goldToGive : int = 1
 
# function to be called,
# in the player scene script if a raycast2D node collides with this object and the interact button is pressed
func on_interact (player):
	Highscore.add_to_score()
	player.give_gold(goldToGive) # Gves x amount of gold to player, eg the loot in this chest
	print("Player has received 1 gold!")
	queue_free() # deletes node from the scene, eg loot has been collected and now the chest disappears
