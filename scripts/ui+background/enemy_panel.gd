extends Panel

@export var enemy_ships : Array[enemy_ship_type]
@export var enemy_spawner : Node
@onready var itemlist = $ItemList
var random_button :bool = true
var target_enemy : enemy_ship_type
func _ready():
	randombutton_toggled(true)
	for i in enemy_ships.size():
		var current_ship = enemy_ships[i]
		var new_visual = current_ship.ship_visual
		itemlist.add_item(current_ship.name,new_visual,true)


func item_list_item_selected(index):
	itemlist.release_focus()
	target_enemy = enemy_ships[index]


func spawn_pressed():
	$Button.release_focus()
	if target_enemy:
		enemy_spawner.spawn_enemy(target_enemy,$max_distance/MAXHSlider.value,$min_distance/MINHSlider.value,$distance/DISTANCEHSlider.value,random_button)


func randombutton_toggled(button_pressed):
	random_button=button_pressed
	if button_pressed:
		$randombutton.modulate = Color(0,1,0,1)
		$distance.visible = false
		$max_distance.visible = true
		$min_distance.visible = true
	else:
		$distance.visible = true
		$max_distance.visible = false
		$min_distance.visible = false
		$randombutton.modulate = Color(1,0,0,1)


func kill_all():
	enemy_spawner.kill_all()
