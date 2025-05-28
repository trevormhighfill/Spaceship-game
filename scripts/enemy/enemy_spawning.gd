extends Node

@export var player : CharacterBody2D
@export var credit_node : Label
var enemy_scene = preload("res://enemy_ship.tscn")

func _ready():
	pass

func spawn_enemy(ship_type : enemy_ship_type, spawn_range : float, spawn_range_min : float = 2500,spawn_distance : float = 0, random : bool = true):
	var new_enemy = enemy_scene.instantiate()
	var pypos = player.position
	var ranx = 0
	var rany = 0
	while ranx == 0:
		ranx = randi_range(-1,1)
	while rany == 0:
		rany = randi_range(-1,1)
	new_enemy.ship_type = ship_type
	new_enemy.player = player
	new_enemy.credit_node = credit_node
	
	if random:
		new_enemy.position = Vector2(randi_range(pypos.x+spawn_range_min,pypos.x+spawn_range)*ranx,randi_range(pypos.y+spawn_range_min,pypos.y+spawn_range)*rany)
	else:
		#new_enemy.position = Vector2(pypos.x + (spawn_range * ranx), pypos.y + (spawn_range * rany))
		new_enemy.position = Vector2(pypos.x + (spawn_distance * ranx), pypos.y + (spawn_distance * rany))
	add_child(new_enemy)

func kill_all():
	for i in get_children():
		i.queue_free()
