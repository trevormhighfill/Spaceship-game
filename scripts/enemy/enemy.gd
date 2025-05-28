extends CharacterBody2D

@export var ship_type : enemy_ship

@onready var CAN_SHOOT = ship_type.CAN_SHOOT
@onready var COLLISION_DAMAGE = ship_type.COLLISION_DAMAGE
@onready var FIRERATE = ship_type.FIRERATE
@onready var BULLET_DAMAGE = ship_type.BULLET_DAMAGE
@onready var BULLET_SPEED = ship_type.BULLET_SPEED

@onready var MAX_HEALTH = ship_type.MAX_HEALTH
@onready var MAX_SPEED = ship_type.MAX_SPEED
@onready var ACCELERATION = ship_type.ACCELERATION
@onready var CREDIT_MIN = ship_type.CREDIT_MIN
@onready var CREDIT_MAX = ship_type.CREDIT_MAX
@onready var COLOR_SCHEME = ship_type.COLOR_SCHEME

var player
var bullet = preload("res://bullet.tscn")
var trail = preload("res://ship_visuals.tscn")
@onready var health = MAX_HEALTH
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
			$"../CanvasLayer/Credit".add_credit(randi_range(CREDIT_MIN,CREDIT_MAX))
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
				get_tree().call_group("ship","hit_with_bullet",COLLISION_DAMAGE,false,self)
				
				if collider.is_in_group("ship"):
					collider.remove_from_group("ship")
					
	if !reload && CAN_SHOOT:
		$firerate.start()
		reload = true
		var instance = bullet.instantiate()
		instance.position = global_transform.basis_xform(Vector2.UP)*70 + position
		instance.start_up(BULLET_DAMAGE,BULLET_SPEED,false,COLOR_SCHEME)
		instance.rotation = rotation
		get_parent().add_child(instance)
		
	var instance = trail.instantiate()
	
	instance.position = position
	instance.rotation = rotation
	instance.modulate = COLOR_SCHEME
	instance.startup(true)
	instance.z_index = -1
	get_parent().add_child(instance)
	
	look_at(player.position)
	rotate(PI/2)
	var pdirection = global_transform.basis_xform(Vector2.UP)
	if true:
		velocity += (pdirection * ACCELERATION * delta)
		velocity = velocity.limit_length(MAX_SPEED)
	move_and_slide()
func firerate_timeout():
	reload = false
