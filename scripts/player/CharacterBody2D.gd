extends CharacterBody2D

#___________________________
var FIRERATE = 0.3
var DAMAGE = 50
var BULLET_SPEED = 60
var hold_to_shoot = false
#___________________________
var MAX_HEALTH = 100
#___________________________
var MAX_SPEED = 1500
var ANGULAR_SPEED = .05
var ACCELERATION = 1500
var DRAG = 300

var COLOR_SCHEME = Color(.4,.4,1,1)
@onready var SHIP_VISUAL = $Ship_visuals/Ship
#___________________________
#___________________________
var bullet = preload("res://bullet.tscn")
var trail = preload("res://ship_visuals.tscn")
var health = 100
var current_speed = 0.0
var reload : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var upgrades_active : Array[upgrade]
#___________________________
#___________________________
func hit_with_bullet(damage,team,hit_bullet):
	remove_from_group("ship")
	if team == false:
		hit_bullet.queue_free()
		health -= damage
		if health <= 0:
			get_tree().change_scene_to_file("res://main.tscn")
func _ready():
	$firerate.wait_time = FIRERATE
func _input(event):
	if event.is_action_pressed("fire") && !reload && hold_to_shoot == false:
		$firerate.start()
		reload = true
		var instance = bullet.instantiate()
		instance.position = global_transform.basis_xform(Vector2.UP)*70 + position
		instance.start_up(DAMAGE,BULLET_SPEED,true,COLOR_SCHEME)
		instance.rotation = rotation
		get_parent().add_child(instance)
func change_ship(new_ship : ship):
	hold_to_shoot = new_ship.hold_to_shoot
	FIRERATE = new_ship.FIRERATE
	DAMAGE = new_ship.DAMAGE
	BULLET_SPEED = new_ship.BULLET_SPEED
	MAX_HEALTH = new_ship.MAX_HEALTH
	MAX_SPEED = new_ship.MAX_SPEED
	ANGULAR_SPEED = new_ship.ANGULAR_SPEED
	ACCELERATION = new_ship.ACCELERATION
	DRAG = new_ship.DRAG
	COLOR_SCHEME = new_ship.COLOR_SCHEME
	SHIP_VISUAL.texture = new_ship.ship_visual
	$firerate.wait_time = FIRERATE
	reload_upgrades()
func reload_upgrades():
	for i in upgrades_active.size():
		add_upgrade(upgrades_active[i])
func add_upgrade(added_upgrade : upgrade):
	if added_upgrade.effect_hold_to_shoot:
		hold_to_shoot = added_upgrade.hold_to_shoot
	FIRERATE += added_upgrade.FIRERATE
	DAMAGE += added_upgrade.DAMAGE
	BULLET_SPEED += added_upgrade.BULLET_SPEED
	MAX_HEALTH += added_upgrade.MAX_HEALTH
	MAX_SPEED += added_upgrade.MAX_SPEED
	ANGULAR_SPEED += added_upgrade.ANGULAR_SPEED
	ACCELERATION += added_upgrade.ACCELERATION
	DRAG += added_upgrade.DRAG
	$firerate.wait_time = FIRERATE
	print("added ", added_upgrade.name)
	print("hold to = ", hold_to_shoot)
	print("firerate ", FIRERATE)
	upgrades_active.append(added_upgrade)
func remove_upgrade(removed_upgrade : upgrade):
	if check_upgrade(removed_upgrade):
		hold_to_shoot = !removed_upgrade.hold_to_shoot
		FIRERATE -= removed_upgrade.FIRERATE
		DAMAGE -= removed_upgrade.DAMAGE
		BULLET_SPEED -= removed_upgrade.BULLET_SPEED
		MAX_HEALTH -= removed_upgrade.MAX_HEALTH
		MAX_SPEED -= removed_upgrade.MAX_SPEED
		ANGULAR_SPEED -= removed_upgrade.ANGULAR_SPEED
		ACCELERATION -= removed_upgrade.ACCELERATION
		DRAG -= removed_upgrade.DRAG
		$firerate.wait_time = FIRERATE
		upgrades_active.erase(upgrades_active.find(removed_upgrade))
func check_upgrade(checked_upgrade):
	if upgrades_active.find(checked_upgrade):
		return true
	else:
		return false
func _process(delta):
	if Input.is_action_pressed("fire") && !reload && hold_to_shoot == true:
		$firerate.start()
		reload = true
		var instance = bullet.instantiate()
		instance.position = global_transform.basis_xform(Vector2.UP)*70 + position
		instance.start_up(DAMAGE,BULLET_SPEED,true,COLOR_SCHEME)
		instance.rotation = rotation
		get_parent().add_child(instance)
func create_trail():
	var instance = trail.instantiate()
	instance.get_node("Ship").texture = SHIP_VISUAL.texture
	instance.position = position
	instance.rotation = rotation
	instance.modulate = COLOR_SCHEME
	instance.startup(true)
	instance.z_index = -1
	get_parent().add_child(instance)
func _physics_process(delta):
	create_trail()
	# Get thge input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var rdirection = Input.get_axis("rotate_right","rotate_left")
	if rdirection:
		
		rotate(-rdirection * ANGULAR_SPEED)
	else:
		#look_at(Vector2(0,0))
		#rotate(PI/2)
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
