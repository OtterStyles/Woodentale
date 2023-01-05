extends Node
class_name ManagerClass

@onready var player: Player = $".."
@onready var playerManager: PlayerManager = $PlayerManager
@onready var itemsManager: ItemsManager = $ItemsManager
@onready var pivotManager: PivotManager = $PivotManager
@onready var inventoryManager: InventoryManager = $InventoryManager
@onready var handHoldManager: HandHoldManager = $HandHoldManager
@onready var equipmentManager: EquipmentManager = $EquipmentManager

func _ready():
	AllPlayerManager.addPlayer(self)
