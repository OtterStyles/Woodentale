extends Node2D
class_name SellBox

@export_category("SellBox")
@export var max_item_size: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hurtbox_area_entered(area):
	SignalManager.openSellBoxDialog.emit()
