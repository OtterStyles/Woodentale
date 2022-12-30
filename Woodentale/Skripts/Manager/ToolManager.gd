extends Node
class_name HandHoldManager

var handHoldType: DataEnums.SubItemType = DataEnums.SubItemType.AXE
var handHoldDamage = 1
var handHoldEffect = ""
var handHoldHitCooldown: bool = false


func changeSprite():
	pass

func changeTool(type: DataEnums.SubItemType):
	handHoldType = type

