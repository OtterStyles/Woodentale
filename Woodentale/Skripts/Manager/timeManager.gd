extends Node
class_name TimeManagerType
@onready var timer: Timer = $timer

var globalTime = 0
var globalDay = 1
var globalMonth = 1
var globalYear = 1

const moths = 5
const days = 30
#const ingameDayinMinutes = 16.0
const ingameDayinMinutes = 1
const defaultWorkHour = 18.0
var ingameDayPerSecond = 0.0
var ingameDaysPerMonth = 24
var ingameMonthsPerYear = 5

#Day = 16 min
#24 Days
#Month = 384 min
#5 Months
#Year = 1920 min = 32 h

signal timeChange
signal dayEnd
signal updateDay
signal updateMonth

func _init():
	ingameDayPerSecond = defaultWorkHour / (ingameDayinMinutes * 60)

func _process(_delta):
	if globalTime >= 24:
		timer.stop()
		dayEnd.emit()
		get_tree().paused = true

func restartDay():
	globalTime = 0
	timer.start()
	addDay()
	get_tree().paused = false

func _on_timer_timeout():
	globalTime += ingameDayPerSecond * timer.wait_time
	timeChange.emit(globalTime)
	timer.start()

func addDay():
	globalDay += 1
	updateDay.emit(globalDay)
	if globalDay >= ingameDaysPerMonth:
		globalDay = 1
		
func addMonth():
	globalMonth += 1
	updateMonth.emit(globalMonth)
	if globalMonth >= ingameMonthsPerYear:
		globalMonth = 1
	

