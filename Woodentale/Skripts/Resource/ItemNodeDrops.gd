extends Resource
class_name ItemNodeDrop

@export var itemID: DataEnums.ItemID = DataEnums.ItemID.WOOD
@export var dropPhase: int = 0
@export_range(0, 1) var dropChance: float = 0
@export var dropMin: int = 0
@export var dropMax: int = 0
