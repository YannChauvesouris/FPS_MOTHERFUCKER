extends Control


onready var ammoText : Label = get_node("AmmoText")
onready var scoreText : Label = get_node("ScoreText")

func update_ammo_text (current_ammo):
	ammoText.text = "Ammo: " + str(current_ammo)
  
func update_score_text (score):
	scoreText.text = "Score: " + str(score)
	

