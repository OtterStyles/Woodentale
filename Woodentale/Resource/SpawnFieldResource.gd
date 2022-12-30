class_name SpawnFieldResource extends Resource

const ItemDrops = preload("res://Skripts/Inventory/itemDrop.gd")

@export var itemID: DataEnums.ItemID = DataEnums.ItemID.WOOD
@export_range(0, 1) var spawnChance = 0
@export var itemDrops: Array[Resource] = []
@export var type: DataEnums.SubItemType = DataEnums.SubItemType.AXE
@export var healths: Array[int] = [1]
