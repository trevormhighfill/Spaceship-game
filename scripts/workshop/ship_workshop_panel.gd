extends Panel

@export var ship_resource : ship
@onready var desc = $desc
@onready var display = $display
@onready var ship_name = $name
@onready var cost = $cost
@onready var credit = get_parent().get_parent().get_parent().get_parent().get_node("Credit")
@onready var player = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("main_ship")
@onready var equipped = false
@export var default_ship = false
# Called when the node enters the scene tree for the first time.
func _ready():
	desc.text = ship_resource.description
	display.texture = ship_resource.ship_visual
	ship_name.text = ship_resource.name
	cost.text = str(ship_resource.price,"C")
	if default_ship:
		$buy.visible = false
		ship_equip()


func ship_bought():
	if credit.credit >= ship_resource.price && !default_ship:
		credit.remove_credit(ship_resource.price)
		print(ship_resource)
		$buy.visible = false
		$equip.visible = true
	else:
		print("too bad")
	$buy.release_focus()
	
func ship_equip():
	print("equipping ",ship_name)
	player.change_ship(ship_resource)
	$equip.visible = false
