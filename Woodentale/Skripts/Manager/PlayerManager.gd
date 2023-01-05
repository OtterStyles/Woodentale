extends Node
class_name PlayerManager

signal updateInventorySlots
signal updateEquipmentSlots
signal updateAccesoirSlots

var inventorySlots: int = 6 :
	get:
		return inventorySlots
	set(value):
		inventorySlots = value
		updateInventorySlots.emit(inventorySlots)

var equipmentSlots: int = 4 :
	get:
		return equipmentSlots
	set(value):
		equipmentSlots = value
		updateEquipmentSlots.emit(equipmentSlots)
		
var accesoirSlots: int = 4 :
	get:
		return accesoirSlots
	set(value):
		accesoirSlots = value
		updateAccesoirSlots.emit(accesoirSlots)
		

func _ready() -> void:
	inventorySlots = inventorySlots
	equipmentSlots = equipmentSlots
	accesoirSlots = accesoirSlots


