extends CharacterBody2D

var player
var FIRERATE = 0.3
var DAMAGE = 10
var BULLET_SPEED = 1
var bullet = preload("res://bullet.tscn")
var trail = preload("res://ship_visuals.tscn")
var health = 100
var max_health = 100
var MAX_SPEED = 1000
var ANGULAR_SPEED = .05
var ACCELERATION = 1500
var DRAG = 1000
var current_speed = 0.0
var reload : bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var aim = get_global_transform().basis

func hit_with_bullet(damage,team,bullet):
	remove_from_group("ship")
	if team == true:
		bullet.queue_free()
		health -= damage
		if health <= 0:
			print("GAMEOVER!!!!!!!!!!!")
			queue_free()

func _ready():
	player = get_parent().find_child("main_ship")
	$firerate.wait_time = FIRERATE
	




func _physics_process(delta):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider =  get_slide_collision(i).get_collider()
		if collider != null:
			if !collider.is_in_group("enemy_ship"):
				collider.add_to_group("ship")
				get_tree().call_group("ship","hit_with_bullet",DAMAGE,false,self)
				if collider.is_in_group("ship"):
					collider.remove_from_group("ship")
			
	if !reload && false:
		$firerate.start()
		reload = true
		var instance = bullet.instantiate()
		instance.position = global_transform.basis_xform(Vector2.UP)*70 + position
		instance.start_up(DAMAGE,BULLET_SPEED,false)
		instance.rotation = rotation
		get_parent().add_child(instance)
	var instance = trail.instantiate()
	instance.position = position
	instance.rotation = rotation
	instance.modulate = Color(1,.4,.4,1)
	instance.startup(true)
	instance.z_index = -1
	get_parent().add_child(instance)
	# Get thge input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	look_at(player.position)
	rotate(PI/2)
	var pdirection = global_transform.basis_xform(Vector2.UP)
	if true:
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
