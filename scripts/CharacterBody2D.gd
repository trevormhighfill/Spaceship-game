extends CharacterBody2D

var FIRERATE = 0.3
var DAMAGE = 50
var BULLET_SPEED = 60
var bullet = preload("res://bullet.tscn")
var trail = preload("res://ship_visuals.tscn")
var health = 100
var max_health = 100
var MAX_SPEED = 1500
var ANGULAR_SPEED = .05
var ACCELERATION = 1500
var DRAG = 100
var current_speed = 0.0
var reload : bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var aim = get_global_transform().basis

func hit_with_bullet(damage,team,bullet):
	remove_from_group("ship")
	if team == false:
		bullet.queue_free()
		health -= damage
		if health <= 0:
			get_tree().change_scene_to_file("res://main.tscn")

func _ready():
	$firerate.wait_time = FIRERATE
	

func _input(event):
	if event.is_action_pressed("fire") && !reload:
		$firerate.start()
		reload = true
		var instance = bullet.instantiate()
		instance.position = global_transform.basis_xform(Vector2.UP)*70 + position
		instance.start_up(DAMAGE,BULLET_SPEED,true)
		instance.rotation = rotation
		get_parent().add_child(instance)

func _physics_process(delta):
	var instance = trail.instantiate()
	instance.position = position
	instance.rotation = rotation
	instance.modulate = Color(.4,.4,1,1)
	instance.startup(true)
	instance.z_index = -1
	get_parent().add_child(instance)
	# Get thge input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var rdirection = Input.get_axis("rotate_right","rotate_left")
	if rdirection:
		
		rotate(-rdirection * ANGULAR_SPEED)
	else:
		rotate(0)
	var pdirection = global_transform.basis_xform(Vector2.UP)
	if Input.is_action_pressed("foward"):
		velocity += (pdirection * ACCELERATION * delta)
		velocity = velocity.limit_length(MAX_SPEED)
	else:
		if velocity.length() > (DRAG * delta):
			velocity -= velocity.normalized() * (DRAG * delta)
		else:
			velocity = Vector2.ZERO
	
	
	move_and_slide()


func firerate_timeout():
	reload = false
