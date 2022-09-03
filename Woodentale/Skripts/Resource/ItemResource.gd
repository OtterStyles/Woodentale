extends Resource
class_name ItemResource

@export_category("Item")
@export var mainType: Enums.MainType = Enums.MainType.ITEM
@export var itemType: Enums.ItemType = Enums.ItemType.RESOURCE
@export var itemSubType: Enums.SubItemType = Enums.SubItemType.NONE

@export_category("Stats")
@export_range(1,2) var speed = 1
@export_range(1,2) var stamina = 1
@export_range(1,2) var damage = 1
@export_range(1,2) var collectionRadius = 1
@export_range(1,2) var fishingBonus = 1
@export_range(1,2) var miningBonus = 1

func _init():
	pass
