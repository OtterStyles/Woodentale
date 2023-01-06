extends Node
class_name HandHoldManager

var type: DataEnums.SubItemType = DataEnums.SubItemType.AXE
var item: ItemResource = null
var coolDown: bool = false

signal changeToolStamina

func itemInit(_item: ItemResource):
	item = _item
	type = _item.itemSubType

func changeItem(_item: ItemResource):
	item = _item
	if item:
		type = _item.itemSubType
		return
	type = DataEnums.SubItemType.HAND

func getDamage() -> int:
	if not item: return 0
	return item.damage
	
func getCritDamage() ->int:
	if not item: return 0
	return item.critDamage


func useTool():
	if not item: return
	if item.hasStamina and item.valueStamina <= item.maxStamina and item.valueStamina >= 1:
		item.valueStamina -= 1
		changeToolStamina.emit(item.valueStamina, item)
		
		
