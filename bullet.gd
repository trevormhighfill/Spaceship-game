extends Area2D

var SPEED = 30
var DAMAGE : float = 10

var player_team : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_up(set_damage,team):
	player_team = team
	DAMAGE = set_damage
	if !player_team:
		$Sprite2D.modulate = Color(1,0,0,1)
	else:
		$Sprite2D.modulate = Color(.8,0,1,1)

func _physics_process(delta):
	position += global_transform.basis_xform(Vector2.UP)*SPEED


func timer_timeout():
	queue_free()


func area_entered(area):
	area.hit_with_bullet(DAMAGE,player_team,self)
	print("banana ", DAMAGE)
	
