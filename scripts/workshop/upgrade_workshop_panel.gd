extends Panel

@export var upgrade_resource : upgrade
@onready var desc = $desc
@onready var display = $display
@onready var upgrade_name = $name
@onready var cost = $cost
@onready var credit = get_parent().get_parent().get_parent().get_parent().get_node("Credit")
@onready var player = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("main_ship")
# Called when the node enters the scene tree for the first time.
func _ready():
	desc.text = upgrade_resource.description
	display.texture = upgrade_resource.display
	upgrade_name.text = upgrade_resource.name
	cost.text = str(upgrade_resource.price,"C")


func upgrade_bought():
	if credit.credit >= upgrade_resource.price:
		credit.remove_credit(upgrade_resource.price)
		print("bought ", upgrade_resource.name)
		player.add_upgrade(upgrade_resource)
		visible = false
	else:
		print("too bad")
	$buy.release_focus()
