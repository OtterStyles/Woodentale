extends StaticBody2D
class_name ItemNode

var itemNodeDrops: Array[Resource] = [] #ItemNodeDrop
var type: DataEnums.SubItemType = DataEnums.SubItemType.AXE
var healths: Array[int] = [5]
var itemID: DataEnums.ItemID = DataEnums.ItemID.WOOD
var item: ItemResource = null
var nodePhase: int = 0
var isMultiPhase: bool = false

func setItemID(_itemID: DataEnums.ItemID) -> void:
	itemID = _itemID
	item = ItemLoader.getItem(itemID)
	
func setHealths(_healths: Array[int]) -> void:
	healths.clear()
	healths.append_array(_healths)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var player = area.get_parent().get_parent()
	var handHoldManager: HandHoldManager = AllPlayerManager.getManagerByPlayer(player).handHoldManager
	if type == handHoldManager.type and handHoldManager.coolDown:
		handHoldManager.coolDown = true
		healths[nodePhase] -= handHoldManager.getDamage()
		if healths[nodePhase] <= 0 and isMultiPhase and nodePhase < len(item.activeAtlas) - 1:
			dropItems()
			nodePhase += 1
			$sprite2D.texture = item.activeAtlas[nodePhase]
			calculateOffsetSprite()
		elif healths[nodePhase] <= 0:
			dropItems()
			queue_free()

func changeSprite() -> void:
	if len(item.activeAtlas) == 1:
		$sprite2D.texture = item.activeAtlas[0]
	elif len(item.activeAtlas) > 1:
		$sprite2D.texture = item.activeAtlas[0]
		togleMutltiPhase()
	calculateOffsetSprite()
	
func calculateOffsetSprite() -> void:
	var sprite: Sprite2D = $sprite2D
	var texture: Texture2D = $sprite2D.texture
	var size = texture.get_size()
	size.x = -size.x/2
	size.y = -size.y
	sprite.offset = size

func togleMutltiPhase() -> void:
	isMultiPhase = true
	if len(item.activeAtlas) > len(healths):
		for i in range(len(item.activeAtlas) - len(healths)):
			healths.append(0)
		
func dropItems() -> void:
	for itemNodeDrop in itemNodeDrops:
		if itemNodeDrop is ItemNodeDrop and itemNodeDrop.dropPhase == nodePhase:
			for i in range(quantityDrop(itemNodeDrop.dropMin, itemNodeDrop.dropMax)):
				if doDrop(itemNodeDrop.dropChance):
					$"../ItemOutlet".addItemToQueue(itemNodeDrop, global_position)

func doDrop(percent: int) -> bool:
	return randf_range(0,1) <= percent

func quantityDrop(minRange: int, maxRange: int) -> int:
	return randi_range(minRange, maxRange)
