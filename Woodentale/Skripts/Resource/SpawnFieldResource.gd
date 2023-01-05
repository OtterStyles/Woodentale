extends Resource
class_name SpawnFieldResource

@export var itemID: DataEnums.ItemID = DataEnums.ItemID.WOOD
@export_range(0, 1) var spawnChance = 0
@export var itemNodeDrops: Array[Resource] = [] #ItemNodeDrop
@export var type: DataEnums.SubItemType = DataEnums.SubItemType.AXE
@export var healths: Array[int] = [1]
