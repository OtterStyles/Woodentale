extends TextureRect
class_name BookTexture

@export var inv6Slots: Texture2D
@export var inv18Slots: Texture2D
@export var inv30Slots: Texture2D


func updateInventorySlots(inventorySlots: int):
	if inventorySlots == 6:
		texture = inv6Slots
	elif inventorySlots == 18:
		texture = inv18Slots
	else:
		texture = inv30Slots
		
func updateEquipmentSlots(_equipmentSlots: int):
	pass
	
func updateAccesoirSlots(_accesiorSlots: int):
	pass
