extends Panel

@export var upgrade_resource : upgrade
@onready var desc = $desc
@onready var display = $display
@onready var upgrade_name = $name
@onready var cost = $cost
# Called when the node enters the scene tree for the first time.
func _ready():
	desc.text = upgrade_resource.description
	display.texture = upgrade_resource.display
	upgrade_name.text = upgrade_resource.name
	cost.text = str(upgrade_resource.price,"C")
