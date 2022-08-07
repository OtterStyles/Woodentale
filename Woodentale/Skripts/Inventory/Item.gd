extends Node2D

var item_name
var item_quantity
@onready var sprite = $Sprite2D


func _ready():
	var rand_val = randi() % 3
	if rand_val == 0:
		item_name = "Squisch Blue"
	elif rand_val == 1:
		item_name = "Squisch Green"
	elif rand_val == 2:
		item_name = "Squisch Red"
	sprite.frame = rand_val
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		changeLabel()
	

func addItemQuantity(amountToAdd: int) -> void:
	item_quantity += amountToAdd
	changeLabel()
	
func decreaseItemQuantity(amountToDecreas: int) -> void:
	item_quantity -= amountToDecreas
	changeLabel()
	
func changeLabel() -> void:
	$Label.text = str(item_quantity)
	
	
		
