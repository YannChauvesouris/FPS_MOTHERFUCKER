extends KinematicBody

var speed = 10
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 45
var jump = 15
var jump_num = 0

var cam_accel = 40
var mouse_sense = 0.1
var snap

var damage= 10

var ammo : int = 15  #teste
var score : int = 0

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var aimcast = $Head/Camera/Aimcast
onready var anim_player = $AnimationPlayer
onready var particules = $Head/Camera/Hand/weapon/Particles
onready var particules2 = $Head/Camera/Hand/weapon/Particles2

onready var b_decal =  preload("res://Bulletdecal.tscn")

export var fire_time = 1
var can_fire = true


func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
		ui.update_ammo_text(ammo)
		ui.update_score_text(score)
		
func fire():
	if Input.is_action_just_pressed("fire") and can_fire:

		if not anim_player.is_playing():
			if aimcast.is_colliding():
				var target = aimcast.get_collider()

				if target.is_in_group("Enemy"):
					var b = b_decal.instance() #testtutobullethole
					aimcast.get_tree().get_root().add_child(b)
					b.global_transform.origin = aimcast.get_collision_point()
					b.look_at(aimcast.get_collision_point() +  aimcast.get_collision_normal(), Vector3.UP)
					print ("hit ennemy")
					target.health -= damage
					anim_player.play("FireGun")
					particules.emitting = true
					particules2.emitting = true
					ammo -= 1
					if ammo == 0:
						_reload()

				elif target.is_in_group("wall"):
					var b = b_decal.instance() #testtutobullethole
					aimcast.get_tree().get_root().add_child(b)
					b.global_transform.origin = aimcast.get_collision_point()
					b.look_at(aimcast.get_collision_point() +  aimcast.get_collision_normal(), Vector3.UP) #fin bullethole
					anim_player.play("FireGun")
					particules.emitting = true
					particules2.emitting = true
					ammo -= 1
					if ammo == 0:
						_reload()
		else:
			anim_player.stop()

				
func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform


func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_num == 0
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
		jump_num = 1
		
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_num == 1:
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jump
			jump_num = 2
			
		
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
	fire()
	
func add_score(amount):
	score += amount
	
	
onready var ui : Node = get_node("/root/World 3/CanvasLayer/UI")  #UI


		
		
		
	
func _reload():
	if ammo == 0:
		anim_player.play("Reloading")
		can_fire = false
		print("reloading")
		yield(get_tree().create_timer(fire_time), "timeout")
		ammo = 15
		can_fire = true
		print("reloaded")


