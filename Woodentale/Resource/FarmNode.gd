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
		print("plant")
		crop = handHoldManager.item
		crop_outlet.visible = true
	elif isHoed and DataEnums.SubItemType.WATERING_CAN == handHoldManager.type and not handHoldManager.coolDown and handHoldManager.currentToolProgressBar >= 0:
		base.frame = 1
		isWatered = true
		lastDehydrated = TimeManager.globalDay
		print(lastDehydrated)


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
		if dayHydrated % crop.duration == 0:
			crop_outlet.frame = startFrame + (dayHydrated / crop.duration)
		isWatered = false
		base.frame = 0
	elif isWatered:
		isWatered = false
		base.frame = 0
		
