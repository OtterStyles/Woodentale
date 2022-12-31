extends Node
class_name HandHoldManager

var type: DataEnums.SubItemType = DataEnums.SubItemType.AXE
var item: ItemResource = null
var currentToolProgressBar = 0
var coolDown: bool = false

signal changeProgressBarSignal

func itemInit(_item: ItemResource):
	item = _item
	type = _item.itemSubType
	var currentToolProgressBar = _item.usesToolProgressBar

func changeItem(_item: ItemResource):
	item = _item
	if item:
		type = _item.itemSubType
		var currentToolProgressBar = _item.usesToolProgressBar
		return
	type = DataEnums.SubItemType.HAND
	var currentToolProgressBar = 0

func getDamage() -> int:
	if not item: return 0
	return item.damage
	
func getCritDamage() ->int:
	if not item: return 0
	return item.critDamage



func useTool():
	if not item: return
	if item.hasToolProgressBar and currentToolProgressBar <= item.usesToolProgressBar and currentToolProgressBar >= 1:
		currentToolProgressBar -= 1
		changeProgressBarSignal.emit(currentToolProgressBar)
		
		
