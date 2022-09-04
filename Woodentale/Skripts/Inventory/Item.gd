extends Node2D
class_name ItemData

var itemID: int
var item_quantity: int
var mainType: DataEnums.MainType
var itemType: DataEnums.ItemType
var itemSubType: DataEnums.SubItemType
var item: ItemResource

func setItem(newID: int, newItemQuantity: int) -> void:
	itemID = newID
	item_quantity = newItemQuantity
	item = ItemLoader.getItem(itemID)
	if item:
		$Sprite2D.frame = int(item.atlasFrame)
		mainType = item.mainType
		itemType = item.itemType
		itemSubType = item.itemSubType
		if item.stackSize <= 1:
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

