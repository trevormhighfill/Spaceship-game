extends Node

@export var player : CharacterBody2D
var enemy_scene = preload("res://enemy_ship.tscn")

func _ready():
	pass

func spawn_enemy(ship_type : enemy_ship_type):
	var new_enemy = enemy_scene

