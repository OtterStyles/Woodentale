extends StaticBody2D

@onready var base: Sprite2D = $Base
@onready var crop_outlet: Sprite2D = $CropOutlet
var isWatered: bool = false
var fertilizer = ""
var initDay = 0
var dehyderationPeriod = 2
var lastDehydrated = 0
var crop = null


# Called when the node enters the scene tree for the first time.
func _ready():#
	TimeManager.connect("timeChange",timeChange)
	base.visible = false
	crop_outlet.visible = false

func onHydrate():
	lastDehydrated = TimeManager.globalTime
	

func _on_farm_node_area_entered(area):
	var player = area.get_parent().get_parent().name
	var handHoldManager: HandHoldManager = AllPlayerManager.players[player].handHoldManager
	if DataEnums.SubItemType.HOE == handHoldManager.handHoldType and not handHoldManager.handHoldHitCooldown:
		initDay = TimeManager.globalTime
		lastDehydrated = TimeManager.globalTime
		base.visible = true
	elif DataEnums.SubItemType.SEED == handHoldManager.handHoldType and not handHoldManager.handHoldHitCooldown:
		crop = "potatoe"
		crop_outlet.visible = true
		


func timeChange(time):
	if lastDehydrated + dehyderationPeriod <=time and not crop:
		base.visible = false
		crop_outlet.visible = false
		fertilizer = ""
		
