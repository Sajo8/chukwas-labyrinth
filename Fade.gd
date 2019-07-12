extends CanvasLayer

signal finished

var start_time = 0
var duration = 500

var fade_in = false

onready var rect = $ColorRect

func _ready():
	start_time = OS.get_ticks_msec()
	rect.set_size(rect.get_viewport_rect().size)
	set_process(true)

func set_fade_in(fade_in):
	self.fade_in = fade_in

func _process(delta):
	var alpha = float(OS.get_ticks_msec() - start_time) / duration
	alpha = clamp (alpha, 0, 1)
	
	# Finished fading
	if alpha == 1:
		emit_signal("finished")
		queue_free()
	
	if fade_in:
		alpha = 1 - alpha
	
	rect.color.a = alpha