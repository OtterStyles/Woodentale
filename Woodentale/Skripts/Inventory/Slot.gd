extends Panel
class_name Slot

@export_category("Type")
@export var mainType: DataEnums.MainType = DataEnums.MainType.ITEM
@export var itemType: DataEnums.ItemType = DataEnums.ItemType.RESOURCE
@export var itemSubType: DataEnums.SubItemType = DataEnums.SubItemType.NONE

const ItemType = preload("res://PreFab/Inventory/item.tscn")
var itemData: ItemData = null
var activated: bool = false
var updateByQuantity = 0

func _process(_delta) -> void:
	visible = activated

func initializeItem(item_id: int, item_quantity: int) -> void:
	if itemData == null:
		itemData = ItemType.instantiate()
		itemData.setItem(item_id, item_quantity)
		itemData.setToolStamina(false, 0)
		add_child(itemData)
	else:
		itemData.setItem(item_id, item_quantity)
		itemData.setToolStamina(false, 0)
	tooltip_text = itemData.itemDescription

func pickFromSlot(type: DataEnums.PickSize) -> ItemData:
	if not itemData:
		return itemData
	var invItem: ItemData = matchTypeAndCreateInvItem(itemData, type)
	if itemData.item_quantity > updateByQuantity:
		itemData.decreaseItemQuantity(updateByQuantity)
	else:
		remove_child(itemData)
		itemData = null
	return invItem

func putIntoSlot(holding_item: ItemData, type: DataEnums.PickSize) -> ItemData:
	if itemData:
		return holding_item
	itemData = matchTypeAndCreateInvItem(holding_item, type)
	itemData.position = Vector2.ZERO
	add_child(itemData)
	holding_item.decreaseItemQuantity(updateByQuantity)
	if holding_item.item_quantity <= 0:
		return null
	return holding_item

func matchTypeAndCreateInvItem(byItem: ItemData,type: DataEnums.PickSize) -> ItemData:
	var invItem: ItemData = ItemType.instantiate()
	invItem.setToolStamina(false, 0)
	match type:
		DataEnums.PickSize.ONE:
			invItem.setItem(byItem.itemID,1)
			updateByQuantity = 1
		DataEnums.PickSize.HALF:
			invItem.setItem(byItem.itemID, roundi(byItem.item_quantity/2))
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
