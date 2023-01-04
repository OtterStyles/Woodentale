extends StaticBody2D

@onready var base: Sprite2D = $Base
@onready var crop_outlet: Sprite2D = $CropOutlet
var isWatered: bool = false
var isHoed: bool = false
var fertilizer = ""
var initDay = 0
var dehyderationPeriod = 2
var lastDehydrated = 0
var dayHydrated = 0
var crop = null


# Called when the node enters the scene tree for the first time.
func _ready():#
	TimeManager.connect("updateDay",timeChange)
	base.visible = false
	crop_outlet.visible = false

func onHydrate():
	lastDehydrated = TimeManager.globalTime
	

func _on_farm_node_area_entered(area):
	var player = area.get_parent().get_parent().name
	var handHoldManager: HandHoldManager = AllPlayerManager.players[player].handHoldManager
	if DataEnums.SubItemType.HOE == handHoldManager.type and not handHoldManager.coolDown:
		initDay = TimeManager.globalTime
		lastDehydrated = TimeManager.globalTime
		base.visible = true
		isHoed = true
	elif not crop and isHoed and DataEnums.SubItemType.SEED == handHoldManager.type and not handHoldManager.coolDown:
		crop = handHoldManager.item
		crop_outlet.visible = true
	elif isHoed and DataEnums.SubItemType.WATERING_CAN == handHoldManager.type and not handHoldManager.coolDown and handHoldManager.currentToolProgressBar >= 0:
		base.frame = 1
		isWatered = true
		lastDehydrated = TimeManager.globalDay


func timeChange(time):
	if lastDehydrated + dehyderationPeriod <=time and crop == null:
		base.visible = false
		crop_outlet.visible = false
		fertilizer = ""
		isHoed = false
		isWatered = false
	if isWatered and crop:
		dayHydrated += 1
		var startFrame = 0
		if dayHydrated % crop.phaseDuration == 0:
			crop_outlet.frame = startFrame + (dayHydrated / crop.phaseDuration)
		isWatered = false
		base.frame = 0
	elif isWatered:
		isWatered = false
		base.frame = 0
		


func _on_farm_node_area_interact(area):
	var player = area.get_parent().get_parent().name
	var handHoldManager: HandHoldManager = AllPlayerManager.players[player].handHoldManager
	
	print(dayHydrated, crop.duration)
	if crop != null and dayHydrated == crop.duration:
		spawnCrop(crop.spawns)


func spawnCrop(item):
		for i in range(quantityDrop(item.spawnsMin, item.spawnsMax)):
			var newItemDrop : ItemNodeDrops
			newItemDrop.itemID = crop.itemID
			$"../ItemOutlet".addItemToQueue(newItemDrop, global_position)

func doDrop(percent: int) -> bool:
	return randf_range(0,1) <= percent

func quantityDrop(minRange: int, maxRange: int) -> int:
	return randi_range(minRange, maxRange)
