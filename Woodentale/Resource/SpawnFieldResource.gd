class_name SpawnFieldResource extends Resource

@export var itemID: DataEnums.ItemID = DataEnums.ItemID.WOOD
@export_range(0, 1) var spawnChance = 0
@export var itemDrops: Array[Resource] = []
@export var type: DataEnums.ToolTypes = DataEnums.ToolTypes.AXE
@export var healths: Array[int] = [1]
