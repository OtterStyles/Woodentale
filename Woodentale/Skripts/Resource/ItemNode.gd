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
			$sprite2D.texture = load(item.enviromentTextures[nodePhase].get_load_path())
			calculateOffsetSprite()
		elif healths[nodePhase] <= 0:
			dropItems()
			queue_free()

func changeSprite() -> void:
	if len(item.enviromentTextures) == 1:
		$sprite2D.texture = load(item.enviromentTextures[0].get_load_path())
	elif len(item.enviromentTextures) > 1:
		$sprite2D.texture = load(item.enviromentTextures[0].get_load_path())
		togleMutltiPhase()
	calculateOffsetSprite()
	
func calculateOffsetSprite():
	var sprite: Sprite2D = $sprite2D
	var texture: Texture2D = $sprite2D.texture
	var size = texture.get_size()
	size.x = -size.x/2
	if size.y > 64:
		size.y = -32 - 32 * size.y/64
	else:
		size.y = -32
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
					var item = ItemDrop.instantiate()
					item.itemID = itemDrop.itemID
					item.global_position = global_position
					item.velocity = randomVelocity()
					get_parent().call_deferred("add_child", item)

func doDrop(percent: int) -> bool:
	return randf_range(0,1) <= percent

func quantityDrop(minRange: int, maxRange: int) -> int:
	return randi_range(minRange, maxRange)
	
func randomVelocity() -> Vector2:
	var maxRange = 200
	var minRange = -200
	return Vector2(randf_range(minRange,maxRange),randf_range(minRange,maxRange))
