extends Node2D

var is_trail = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func startup(trail):
	is_trail = trail

func _physics_process(delta):
	if is_trail:
		modulate -= Color(0,0.1,0,0.1)
		if modulate.a <= 0:
			queue_free()
