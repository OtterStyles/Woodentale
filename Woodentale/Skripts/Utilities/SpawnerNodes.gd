extends Node2D
class_name FieldSpawnerNodes

@export_category("Category")
@export var farmingEnable = false
@export var resourceEnable = false
@export_category("Spawn Types")
@export_group("Forest")
@export var forest: Array[Resource] = [] #SpawnFieldResource

var farmNode = preload("res://PreFab/Utilities/farm_node.tscn")
var itemNode = preload("res://PreFab/Utilities/itemnode.tscn")
var fieldSpawnerNodes: Array[FieldSpawnerPolygon] = []
var spawnedFieldPositions: Array[Vector2] = []
var spawnPosition: Vector2
var randomPositions = []

func _ready():
	for child in get_children():
		if child is FieldSpawnerPolygon:
			fieldSpawnerNodes.append(child)
			if not child.spawnerType == DataEnums.SpawnTypes.FARMING:
				match child.spawnerType:
					DataEnums.SpawnTypes.FOREST: generateItemNodes(child, forest)
				

func generateItemNodes(itemNode: FieldSpawnerPolygon, types: Array[Resource]):
	var bounds = getPolygonsMinMax(itemNode)
	var tiles = generateNumberOfTiles(itemNode)
	for tile in tiles:
		randomPositionInPolygon(itemNode, bounds)
	for randomPosition in randomPositions:
		spawnPosition = randomPosition
		spawnItemNode(types)
		
func getPolygonsMinMax(itemNode):
	var min_x = itemNode.polygon[0].x
	var max_x = itemNode.polygon[0].x
	var min_y = itemNode.polygon[0]. y
	var max_y = itemNode.polygon[0]. y
	for pos in itemNode.polygon:
		if min_x > pos.x: min_x = pos.x
		if max_x < pos.x: max_x = pos.x
		if min_y > pos.y: min_y = pos.y
		if max_y < pos.y: max_y = pos.y
	return [Vector2(min_x, min_y), Vector2(max_x, max_y)]

func randomPositionInPolygon(itemNode, bounds):
	var randomPoint = Vector2(randf_range(bounds[0].x, bounds[1].x), randf_range(bounds[0].y, bounds[1].y))
	if Geometry2D.is_point_in_polygon(randomPoint, itemNode.polygon) and not randomPoint in randomPositions:
		randomPositions.append(calculateTilePosition(randomPoint))
	else: 
		randomPositionInPolygon(itemNode, bounds)

func generateNumberOfTiles(polygon: FieldSpawnerPolygon):
	var bounds = getPolygonsMinMax(polygon)
	var tiles = 0
	for y in range(bounds[0].y, bounds[1].y, 64):
		for x in range(bounds[0].x, bounds[1].x, 64):
			if Geometry2D.is_point_in_polygon(Vector2(x,y), polygon.polygon):
				tiles += 1
	return tiles

func _on_spawner_nodes_area_entered(area):
	if area is HitBox:
		spawnPosition = calculateTilePosition(area.global_position)
		var activeFieldSpawnerPolygons = getAllFieldNodesInside()
		spawnAllNodes(activeFieldSpawnerPolygons)

func calculateTilePosition(currentPosition: Vector2) -> Vector2:
	var tilePosition = Vector2(currentPosition.x, currentPosition.y)
	tilePosition.x = floori(tilePosition.x / 64) * 64 - 32
	tilePosition.y = floori(tilePosition.y / 64) * 64 - 32
	return tilePosition
	
func getAllFieldNodesInside() -> Array[FieldSpawnerPolygon]:
	var activeFieldSpawnerPolygons: Array[FieldSpawnerPolygon] = []
	for collision in fieldSpawnerNodes:
			if collision.spawnerType != DataEnums.SpawnTypes.FARMING:
				return activeFieldSpawnerPolygons
			if Geometry2D.is_point_in_polygon(spawnPosition, collision.polygon):
				activeFieldSpawnerPolygons.append(collision)
	return activeFieldSpawnerPolygons
	
func spawnAllNodes(activeFieldSpawnerNodes: Array[FieldSpawnerPolygon]) -> void:
	for activeFieldSpawnerNode in activeFieldSpawnerNodes:
		match activeFieldSpawnerNode.spawnerType:
			DataEnums.SpawnTypes.FARMING: spawnFarmingNodes()
			DataEnums.SpawnTypes.FOREST: spawnItemNode(forest)
		
func spawnFarmingNodes():
	var newFarmNode = farmNode.instantiate()
	newFarmNode.global_position = spawnPosition
	spawnNodesInPlace(newFarmNode)
	
func spawnItemNode(type):
	var activeSpawnNodes = selectRandomSpawnNode(type)
	if randomSpawn(activeSpawnNodes): 
		var newItemNode: ItemNode = itemNode.instantiate()
		var newPosition = spawnPosition
		newPosition.y += 15
		newItemNode.setHealths(activeSpawnNodes.healths)
		newItemNode.type = activeSpawnNodes.type
		newItemNode.itemNodeDrops = activeSpawnNodes.itemNodeDrops
		newItemNode.global_position = newPosition
		newItemNode.setItemID(activeSpawnNodes.itemID)
		newItemNode.changeSprite()
		spawnNodesInPlace(newItemNode)

func spawnNodesInPlace(toSpawnNode) -> void:
	SpawnOutletManager.addNewNode(toSpawnNode)

func selectRandomSpawnNode(type):
	return type[randi_range(0,len(type) - 1)]

func randomSpawn(activeSpawnNodes) -> bool:
	return randi_range(0,1) <= activeSpawnNodes.spawnChance
