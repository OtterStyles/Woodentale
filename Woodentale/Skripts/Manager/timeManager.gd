extends Node

@onready var timer: Timer = $timer
var globalTime = 0
const moths = 5
const days = 30
const ingameDayinMinutes = 16.0
const defaultWorkHour = 18.0
var ingameDayPerSecond = 0.0

signal timeChange
signal dayEnd

func _init():
	ingameDayPerSecond = defaultWorkHour / (ingameDayinMinutes * 60)
	globalTime = 23.5

func _process(delta):
	if globalTime >= 24:
		timer.stop()
		dayEnd.emit()
		get_tree().paused = true
		

func restartDay():
	globalTime = 0
	timer.start()
	get_tree().paused = false

func _on_timer_timeout():
	globalTime += ingameDayPerSecond * timer.wait_time
	timeChange.emit(globalTime)
	timer.start()
