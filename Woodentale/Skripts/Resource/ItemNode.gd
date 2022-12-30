extends StaticBody2D
class_name ItemNode
var itemDrops: Array[Resource] = []
var type: DataEnums.ToolTypes = DataEnums.ToolTypes.AXE
var healths = [5]
var itemID = DataEnums.ItemID.WOOD
var item: ItemResource = null
var nodePhase = 0
var isMultiPhase: bool = false
const ItemDrop = preload("res://PreFab/Inventory/itemDrop.tscn")

func setItemID(_itemID: DataEnums.ItemID):
	itemID = _itemID
	if ItemLoader.itemDirectory.has(itemID):
		item = ItemLoader.itemDirectory[itemID]

func _on_hurtbox_area_entered(area: Area2D):
	var player = area.get_parent().get_parent().name
	var toolManager: ToolManager = AllPlayerManager.players[player].toolManager
	if type == toolManager.toolType and not toolManager.toolHit:
		toolManager.toolHit = true
		healths[nodePhase] -= toolManager.toolDamage
		if healths[nodePhase] <= 0 and isMultiPhase and nodePhase < len(item.enviromentTextures) - 1:
			dropItems()
			nodePhase += 1
			$sprite2D.texture = item.enviromentTextures[nodePhase]
			calculateOffsetSprite()
		elif healths[nodePhase] <= 0:
			dropItems()
			queue_free()

func changeSprite() -> void:
	if len(item.enviromentTextures) == 1:
		$sprite2D.texture = item.enviromentTextures[0]
	elif len(item.enviromentTextures) > 1:
		$sprite2D.texture = item.enviromentTextures[0]
		togleMutltiPhase()
	calculateOffsetSprite()
	
func calculateOffsetSprite():
	var sprite: Sprite2D = $sprite2D
	var texture: Texture2D = $sprite2D.texture
	var size = texture.get_size()
	size.x = -size.x/2
	size.y = -size.y
	sprite.offset = size

func togleMutltiPhase():
	isMultiPhase = true
	if len(item.enviromentTextures) > len(healths):
		for i in range(len(item.enviromentTextures) - len(healths)):
			healths.append(0)
		
func dropItems():
	for itemDrop in itemDrops:
		if itemDrop is ItemNodeDrops and itemDrop.dropPhase == nodePhase:
			for i in range(quantityDrop(itemDrop.dropMin, itemDrop.dropMax)):
				if doDrop(itemDrop.dropChance):
					$"../ItemOutlet".addItemToQueue(itemDrop, global_position)

func doDrop(percent: int) -> bool:
	return randf_range(0,1) <= percent

func quantityDrop(minRange: int, maxRange: int) -> int:
	return randi_range(minRange, maxRange)
