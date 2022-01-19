extends KinematicBody



var health = 30
var scoreToGive : int = 10

onready var player : Node = get_node("/root/World 3/ShooterGuy")

func _ready():
	pass
	
	
func _process(delta):
	if health <= 0:
		die()
		
		
func die ():
	player.add_score(scoreToGive)
	print ("score +1")
	queue_free()
