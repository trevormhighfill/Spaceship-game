extends CharacterBody2D

var DAMAGE = 10
var bullet = preload("res://bullet.tscn")
var health = 100
var max_health = 100
var MAX_SPEED = 1000
var ANGULAR_SPEED = .05
var ACCELERATION = 1500
var DRAG = 100
var current_speed = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var aim = get_global_transform().basis

func hit_with_bullet(damage,team,bullet):
	if team == false:
		bullet.queue_free()
		health -= damage
		if health <= 0:
			print("GAMEOVER!!!!!!!!!!!")
			queue_free()

func _physics_process(delta):
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
	
	if Input.is_action_pressed("fire"):
		var instance = bullet.instantiate()
		instance.position = global_transform.basis_xform(Vector2.UP)*100 + position
		instance.start_up(DAMAGE,true)
		instance.rotation = rotation
		get_parent().add_child(instance)
	
	move_and_slide()
