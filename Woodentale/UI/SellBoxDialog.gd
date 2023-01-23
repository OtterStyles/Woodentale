extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.openSellBoxDialog.connect(openDialog)

func openDialog():
	visible = true
	
func closeDialog():
	visible = false
	SignalManager.closeSellBoxDialog.emit()


func _on_sell_box_dialog_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not Geometry2D.is_point_in_polygon($Polygon2d.polygon, event.position):
			closeDialog()
