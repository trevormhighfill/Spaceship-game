extends CanvasLayer

var slide = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("workshop") && slide:
		get_tree().paused = true
		slide = false
		$Panel/AnimationPlayer.play("workshop_slide")
	elif event.is_action_pressed("workshop"):
		get_tree().paused = false
		slide = true
		$Panel/AnimationPlayer.play("workshop_slide_out")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
