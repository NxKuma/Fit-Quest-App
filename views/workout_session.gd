extends Control

var exerciseLabel: Label
var minutesLabel: Label
var secondsLabel: Label
var button: Button
var isStarted: bool = false

# For stopwatch mechanic
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0

func _ready() -> void:
	exerciseLabel = $"Exercise Container/Exercise Label"
	minutesLabel = $"Exercise Container/Stopwatch/Minutes"
	secondsLabel = $"Exercise Container/Stopwatch/Seconds"
	button = $"Exercise Container/StartOrFinish"
	
	# _process right now is to handle stopwatch. Can migrate to physics_process later
	# if _process is needed for workout session logic 
	set_process(false)

func _process(delta: float) -> void:
	time += delta
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	
	minutesLabel.text = "%02d:" % minutes
	secondsLabel.text = "%02d" % seconds

func _on_start_or_finish_pressed() -> void:
	if (!isStarted):
		isStarted = true
		button.text = "Finish Set"
		set_process(true)
	else:
		isStarted = false
		button.text = "Start Set"
		set_process(false)
		print(get_time_formatted())
		reset_stopwatch()

func reset_stopwatch() -> void:
	time = 0.0
	minutes = 0
	seconds = 0
	minutesLabel.text = "00:"
	secondsLabel.text = "00"

func get_time_formatted() -> String:
	return "%02d:%02d" % [minutes, seconds]
