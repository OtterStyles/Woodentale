extends Node
class_name ManagerClass

@onready var player = $".."
@onready var playerManager: PlayerManager = $PlayerManager
@onready var itemsManager: ItemsManager = $ItemsManager
@onready var pivotManager: PivotManager = $PivotManager
@onready var inventoryManager: InventoryManager = $InventoryManager
@onready var toolManager = $ToolManager
@onready var equipmentManager = $EquipmentManager

func _ready():
	AllPlayerManager.addPlayer(self)
