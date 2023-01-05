extends StaticBody2D
class_name FarmNode

@onready var base: Sprite2D = $Base
@onready var crop_outlet: Sprite2D = $CropOutlet

var ItemNodeType = preload("res://PreFab/Utilities/itemnode.tscn")
var isWatered: bool = false
var isHoed: bool = false
var fertilizer = ""
var initDay = 0
var dehyderationPeriod = 2
var lastDehydrated = 0
var dayHydrated = 0
var seed: ItemResource = null
var crop: ItemResource = null

func _ready() -> void:
	TimeManager.connect("updateDay", updateDay)
	base.visible = false
	crop_outlet.visible = false

func onHydrate() -> void:
	lastDehydrated = TimeManager.globalTime

func _on_farm_node_area_entered(area: Area2D) -> void:
	var player: Player = area.get_parent().get_parent()
	var handHoldManager: HandHoldManager = AllPlayerManager.getManagerByPlayer(player).handHoldManager
	if not crop and not seed and not isHoed and DataEnums.SubItemType.HOE == handHoldManager.type and handHoldManager.coolDown:
		initDay = TimeManager.globalTime
		lastDehydrated = TimeManager.globalTime
		base.visible = true
		isHoed = true
	elif not seed and isHoed and DataEnums.SubItemType.SEED == handHoldManager.type and handHoldManager.coolDown:
		seed = handHoldManager.item
		loadCrop()
		crop_outlet.visible = true
	elif isHoed and DataEnums.SubItemType.WATERING_CAN == handHoldManager.type and handHoldManager.coolDown and handHoldManager.item.valueStamina >= 1:
		base.frame = 1
		isWatered = true
		lastDehydrated = TimeManager.globalDay

func _on_farm_node_area_interact(area: Area2D):
	var player = area.get_parent().get_parent()
	var handHoldManager: HandHoldManager = AllPlayerManager.getManagerByPlayer(player).handHoldManager
	if seed != null and crop != null and dayHydrated == seed.duration:
		spawnCrop(crop)
		vanishCrop()

func updateDay(time: int) -> void:
	if lastDehydrated + dehyderationPeriod <=time and seed == null and isHoed:
		print("Vanish")
		vanishCrop()
	if isWatered and seed:
		print("Grow")
		dayHydrated += 1
		var startFrame = 0
		if dayHydrated % seed.phaseDuration == 0:
			crop_outlet.frame = startFrame + (dayHydrated / seed.phaseDuration)
		isWatered = false
		base.frame = 0
	elif isWatered:
		dayHydrated += 1
		isWatered = false
		base.frame = 0

func spawnCrop(crop: ItemResource) -> void:
		for i in range(quantityDrop(crop.spawnsMin, crop.spawnsMax)):
			var newItemDrop : ItemNodeDrop = ItemNodeDrop.new()
			newItemDrop.itemID = crop.itemID
			$"../ItemOutlet".addItemToQueue(newItemDrop, global_position)

func vanishCrop():
	base.visible = false
	crop_outlet.visible = false
	fertilizer = ""
	isHoed = false
	isWatered = false
	crop == null

func loadCrop() -> void:
	crop = ItemLoader.getItem(seed.spawns)

func doDrop(percent: int) -> bool:
	return randf_range(0,1) <= percent

func quantityDrop(minRange: int, maxRange: int) -> int:
	return randi_range(minRange, maxRange)
