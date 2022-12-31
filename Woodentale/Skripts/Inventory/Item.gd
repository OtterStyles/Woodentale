extends Node2D
class_name ItemData

var itemID: int
var item_quantity: int
var mainType: DataEnums.MainType
var itemType: DataEnums.ItemType
var itemSubType: DataEnums.SubItemType
var itemDescription: String
var item: ItemResource
var itemMaxToolBarUse: int = 0
var isHotBar = false

func setItem(newID: int, newItemQuantity: int) -> void:
	itemID = newID
	item_quantity = newItemQuantity
	item = ItemLoader.getItem(itemID)
	if item:
		if not item.hasToolProgressBar or not isHotBar:
			$Overhead/ToolBarFill.visible = false
		else:
			itemMaxToolBarUse = item.usesToolProgressBar
			changeToolBarFill(item.usesToolProgressBar)
		$Sprite2D.texture = item.itemAtlas
		mainType = item.mainType
		itemType = item.itemType
		itemSubType = item.itemSubType
		itemDescription = item.itemDescription
		if item.stackSize <= 1:
			$Overhead/Label.visible = false
		else:
			changeLabel()

func addItemQuantity(amountToAdd: int) -> void:
	item_quantity += amountToAdd
	changeLabel()
	
func decreaseItemQuantity(amountToDecreas: int) -> void:
	item_quantity -= amountToDecreas
	changeLabel()

func setItemQuantity(amountToSet: int) -> void:
	item_quantity = amountToSet
	changeLabel()
	
func changeLabel() -> void:
	$Overhead/Label.text = str(item_quantity)

func changeToolBarFill(valueProgressBar: int):
	var toolbar : TextureProgressBar = $Overhead/ToolBarFill
	var min = 4
	var max = 96
	var percent = (valueProgressBar / itemMaxToolBarUse) * 100
	toolbar.value = clampi(percent, min, max)
	
func setHotbar(value: bool):
	isHotBar = value
	$Overhead/ToolBarFill.visible = value
	
	
	
	
	
	
