extends Node2D
class_name ItemData

var itemID: int
var item_quantity: int
var mainType: DataEnums.MainType
var itemType: DataEnums.ItemType
var itemSubType: DataEnums.SubItemType
var itemDescription: String
var item: ItemResource
var itemMaxToolBarUse: int = 1
var isHotBar = false

func _ready():
	updateHotFrame(false)

func setItem(newID: int, newItemQuantity: int) -> void:
	itemID = newID
	item_quantity = newItemQuantity
	item = ItemLoader.getItem(itemID)
	if item:
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

func changeToolStamina(valueStamina: int) -> void:
	var toolbar = $Overhead/ToolBarFill
	var min = 4
	var max = 96
	var percent = (float(valueStamina) / float(itemMaxToolBarUse)) * 100
	toolbar.value = clampi(percent, min, max)
	
func setToolStamina(hasStamina: bool, valueStamina: int) -> void:
	$Overhead/ToolBarFill.visible = hasStamina
	itemMaxToolBarUse = valueStamina
	changeToolStamina(valueStamina)

func updateHotFrame(value: bool):
	$Overhead/HotFrame.visible = value
