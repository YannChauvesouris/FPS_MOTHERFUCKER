extends Spatial

const ADS_LERP = 20 #vitesse a laquelle le pistolet change de posotion pour zoomer


export var camera_path : NodePath # fais reference a la camera
var camera : Camera 

export var default_position : Vector3  
export var ads_position : Vector3  #position de zomme/visée

var fview = {"Default": 70, "ADS": 50} #dictionnaire ou plusieurs variable sont stockée
# celle de la fov (zoom de la camera) donc zoom sur le viseur.

func _ready():
	camera = get_node(camera_path)

func _process(delta):
	if Input.is_action_pressed("zoom"):
		transform.origin = transform.origin.linear_interpolate(ads_position, ADS_LERP * delta) # le pistolet va changer de posotion, en finction fr la vitesse de deplacement*
		camera.fov = lerp(camera.fov, fview["ADS"], ADS_LERP * delta) #fais zoomer
	else:
		transform.origin = transform.origin.linear_interpolate(default_position, ADS_LERP * delta) # le refais venire a sa poision d'origine
		camera.fov = lerp(camera.fov, fview["Default"], ADS_LERP * delta) #fais dezoomer
