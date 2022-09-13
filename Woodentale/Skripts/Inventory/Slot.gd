extends Panel

@export_category("Type")
@export var mainType: DataEnums.MainType = DataEnums.MainType.ITEM
@export var itemType: DataEnums.ItemType = DataEnums.ItemType.RESOURCE
@export var itemSubType: DataEnums.SubItemType = DataEnums.SubItemType.NONE

const ItemType = preload("res://PreFab/Inventory/item.tscn")
const ItemClass = preload("res://Skripts/Inventory/Item.gd")
var item: ItemData = null
var updateByQuantity = 0

func _process(_delta):
	if item:
		tooltip_text = item.itemDescription
	

func initializeItem(item_id: int, item_quantity: int) -> void:
	if item == null:
		item = ItemType.instantiate()
		item.setItem(item_id, item_quantity)
		add_child(item)
	else:
		item.setItem(item_id, item_quantity)

func pickFromSlot(type: DataEnums.PickSize) -> ItemData:
	if not item:
		return item
	var invItem: ItemData = matchTypeAndCreateInvItem(item, type)
	if item.item_quantity > updateByQuantity:
		item.decreaseItemQuantity(updateByQuantity)
	else:
		remove_child(item)
		item = null
	return invItem

func putIntoSlot(holding_item: ItemClass, type: DataEnums.PickSize) -> ItemClass:
	if item:
		return holding_item
	item = matchTypeAndCreateInvItem(holding_item, type)
	item.position = Vector2.ZERO
	add_child(item)
	holding_item.decreaseItemQuantity(updateByQuantity)
	if holding_item.item_quantity <= 0:
		return null
	return holding_item
		


func matchTypeAndCreateInvItem(byItem: ItemData,type: DataEnums.PickSize) -> ItemData:
	var invItem: ItemData = ItemType.instantiate()
	match type:
		DataEnums.PickSize.ONE:
			invItem.setItem(byItem.itemID,1)
			updateByQuantity = 1
		DataEnums.PickSize.HALF:
			invItem.setItem(byItem.itemID, int(byItem.item_quantity/2))
			updateByQuantity = invItem.item_quantity
		DataEnums.PickSize.FULL:
			invItem.setItem(byItem.itemID, byItem.item_quantity)
			updateByQuantity = byItem.item_quantity
		DataEnums.PickSize.MINSTACKSIZE:
			if byItem.item_quantity >= DataConstants.MIN_STACK:
				invItem.setItem(byItem.itemID, DataConstants.MIN_STACK)
			else:
				invItem.setItem(byItem.itemID, byItem.item_quantity)
			updateByQuantity = DataConstants.MIN_STACK
	return invItem
