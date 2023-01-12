extends Node2D

func _ready():
	SignalManager.closeBedDialog.connect(startSleep)

func _on_hurtbox_area_entered(area):
	if area.get_parent().get_parent() is Player:
		openSleepDialog()

func startSleep(respond: bool):
	print(respond)
	if respond:
		TimeManager.endDay.emit()

func openSleepDialog():
	SignalManager.openBedDialog.emit()
