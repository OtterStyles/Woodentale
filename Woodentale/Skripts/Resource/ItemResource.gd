extends Resource
class_name ItemResource
@export_category("Algemein")
@export var itemName: String = ""
@export var itemID: DataEnums.ItemID = DataEnums.ItemID.WOOD
const stackSizeFlags = ["1","15","30","60","120","240","480","960"]
@export_enum("1","15","30","60","120","240","480", "960") var stackSizeEnum = 0
var stackSize = 0
@export_multiline var itemDescription = "New Description"

@export_category("Type")
@export var mainType: DataEnums.MainType = DataEnums.MainType.ITEM
@export var itemType: DataEnums.ItemType = DataEnums.ItemType.RESOURCE
@export var itemSubType: DataEnums.SubItemType = DataEnums.SubItemType.NONE
@export_category("Stats")
@export_group("PlayerAttribute")
@export_range(1,2) var speed = 1
@export_range(1,2) var stamina = 1
@export_range(1,2) var damage = 1
@export_group("ToolAttribute")
@export_range(1,2) var workSpeed = 1
@export_range(1,2) var critDamage = 1
@export var workHeight = 1
@export var workWidth = 1
@export var hasToolProgressBar: bool = false
@export var usesToolProgressBar: int = 1
@export_range(1,4) var collectionRadius = 1
@export_range(1,2) var fishingBonus = 1
@export_range(1,2) var miningBonus = 1
@export_group("PlaceAbles")
@export var placeHeight = 1
@export var placeWidth = 1
@export_group("Crops")
@export var duration = 4
@export var phaseDuration = 1
@export var spawns: DataEnums.ItemID = DataEnums.ItemID.POTATO 
@export var spawnsMin: int = 1
@export var spawnsMax: int = 3
@export_category("Atlas")
@export var itemAtlas: Texture2D
@export var activeAtlas: Array[Texture2D] = []

