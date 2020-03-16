extends Control

var label_text = "Remaining Time: "

onready var timer = $Timer
onready var label = $Label

export var timer_duration = 300 setget set_timer_duration, get_timer_duration

signal timer_timeout

func _ready():
	timer.set_wait_time(timer_duration)
	timer.start()

func _process(_delta):
	# Get time left in seconds and round it to an int
	var time_left = timer.get_time_left()
	time_left = round(time_left)
	time_left = int(time_left)

	# Get minutes remaining
	var time_left_m = time_left / 60
	time_left_m = round(time_left_m)

	# Get seconds remaining
	var time_left_s = time_left % 60

	# Make str of remaining time: "3m 37s"
	var time_left_m_s = str(time_left_m) + "m " + str(time_left_s) + "s"

	# Make full text
	label_text = "Remaining Time: " + time_left_m_s

	# Assign new text
	label.text = label_text

func _on_Timer_timeout():
	emit_signal("timer_timeout")

func set_timer_duration(new_duration):
	timer_duration = new_duration

func get_timer_duration():
	return timer_duration
