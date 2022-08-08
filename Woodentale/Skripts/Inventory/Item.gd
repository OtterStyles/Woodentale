extends Node2D

var item_name: String
var item_quantity: int


func setItem(set_name: String, set_quantity: int) -> void:
	item_name = set_name
	item_quantity = set_quantity
	var jsonData = JsonData.item_data[item_name]
	var stack_size = int(jsonData["StackSize"])
	$Sprite2D.frame = int(jsonData["AtlasFrame"])
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

