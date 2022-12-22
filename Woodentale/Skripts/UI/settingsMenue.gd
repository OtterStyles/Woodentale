extends ColorRect
@onready var exit_button = %exitButton
@onready var animation_player = $animationPlayer
@onready var tab_bar: TabBar = $centerContainer/vBoxContainer/tabBar
@onready var tab_container: TabContainer = $centerContainer/vBoxContainer/tabContainer
signal changeToPause

func _ready():
	exit_button.pressed.connect(disable)
	tab_bar.tab_clicked.connect(changeTab)
	visible = false

func enable() -> void:
	animation_player.play("enable")
	
func disable() -> void:
	animation_player.play("disable")
	changeToPause.emit()

func changeTab(tabIndex: int):
	tab_container.current_tab = tabIndex
