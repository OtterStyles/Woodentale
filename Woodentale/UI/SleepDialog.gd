extends VBoxContainer

@onready var close: Button = $HBoxContainer/VBoxContainer2/HBoxContainer/Close
@onready var exit: Button = $HBoxContainer/VBoxContainer2/HBoxContainer/Exit


func _ready():
	visible = false
	SignalManager.openBedDialog.connect(openDialog)
	close.pressed.connect(closeDialogPositiv)
	exit.pressed.connect(closeDialogNegativ)


func closeDialogPositiv():
	SignalManager.closeBedDialog.emit(true)
	visible = false

func closeDialogNegativ():
	SignalManager.closeBedDialog.emit(false)
	visible = false
	
func openDialog():
	visible = true
	
func _process(delta):
	pass


