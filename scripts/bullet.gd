extends Area2D
signal hit_with_bullet(damage:int,team:bool,node:Node2D)
var SPEED = 30
var DAMAGE : float = 10

var player_team : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_up(set_damage,bullet_speed,team):
	player_team = team
	DAMAGE = set_damage
	SPEED = bullet_speed
	if !player_team:
		$Sprite2D.modulate = Color(1,.4,.4,1)
	else:
		$Sprite2D.modulate = Color(.4,.4,1,1)

func _physics_process(delta):
	position += global_transform.basis_xform(Vector2.UP)*SPEED


func timer_timeout():
	queue_free()


func area_entered(area):
	area.add_to_group("ship")
	get_tree().call_group("ship","hit_with_bullet",DAMAGE,player_team,self)
	if area.is_in_group("ship"):
		area.remove_from_group("ship")
	
