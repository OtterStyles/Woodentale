extends StaticBody2D
@export var itemDrops: Array[Resource] = []
@export var type: DataEnums.ToolTypes = DataEnums.ToolTypes.AXE
@export var health = 5

const ItemDrop = preload("res://PreFab/Inventory/itemDrop.tscn")
func _on_hurtbox_area_entered(area: Area2D):
	var player = area.get_parent().get_parent().name
	var toolManager: ToolManager = AllPlayerManager.players[player].toolManager
	if type == toolManager.toolType:
		health -= toolManager.toolDamage
		if health <= 0:
			dropItems()
			queue_free()

func dropItems():
	for itemDrop in itemDrops:
		if itemDrop is ItemNodeDrops:
			for i in range(quantityDrop(itemDrop.dropMin, itemDrop.dropMax)):
				if doDrop(itemDrop.dropChance):
					var item = ItemDrop.instantiate()
					item.itemID = itemDrop.itemID
					item.global_position = global_position
					item.velocity = randomVelocity()
					get_parent().call_deferred("add_child", item)

func doDrop(percent: int) -> bool:
	return randf_range(0,100) <= percent

func quantityDrop(minRange: int, maxRange: int) -> int:
	return randi_range(minRange, maxRange)
	
func randomVelocity() -> Vector2:
	var maxRange = 200
	var minRange = -200
	return Vector2(randf_range(minRange,maxRange),randf_range(minRange,maxRange))
