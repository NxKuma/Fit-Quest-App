extends Control

# Routine logic
var exerciseLabel: Label
var routineTitle: Label
var routine: WorkoutRoutine
var currentExercise: int = 0
var button: Button
var isWorking: bool = false
var exerciseDone: bool = false

# For stopwatch mechanic
var minutesLabel: Label
var secondsLabel: Label
var msecondsLabel: Label
var countdown: Label
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var mseconds: int = 0
var maxTime: int = 3

func load_routine():
	routine = Global.get_routine_today()

func _ready() -> void:
	routineTitle = $"Header/Routine Title"
	exerciseLabel = $"Exercise Container/Exercise Label"
	minutesLabel = $"Exercise Container/Stopwatch/Minutes"
	secondsLabel = $"Exercise Container/Stopwatch/Seconds"
	msecondsLabel = $"Exercise Container/Stopwatch/Milliseconds"
	countdown = $Countdown
	button = $"Exercise Container/StartOrFinish"
	exerciseLabel = $"Exercise Container/Exercise Label"
	
	load_routine()
	
	routineTitle.text = routine.routine_name
	if (routine.routine_name == "Rest"):
		set_process(false)
		countdown.visible = true
		countdown.text = "Rest day\ntoday!"
		button.disabled = true
		exerciseLabel.text = ""
	else:
		exerciseLabel.text = routine.exercises[currentExercise].exercise_name
		countdown.visible = false
		
		
	
	# Setting up scene
	# For label
	
	# _physics_process right now is to handle stopwatch. Can migrate to physics_process later
	# if _physics_process is needed for workout session logic 
	set_physics_process(false)

func _process(delta: float) -> void:
	if (currentExercise >= routine.exercises.size()):
		countdown.visible = true
		countdown.text = "Done!"
		button.disabled = true
		return
	
	exerciseLabel.text = routine.exercises[currentExercise].exercise_name

func _physics_process(delta: float) -> void:
	time += delta
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	mseconds = fmod(time, 1) * 100
	if (!exerciseDone):
		play_countdown()
	else:
		minutesLabel.text = "%02d:" % minutes
		secondsLabel.text = "%02d." % seconds
		msecondsLabel.text = "%02d" % mseconds

func _on_start_or_finish_pressed() -> void:
	if (!isWorking):
		isWorking = true
		button.text = "Finish Set"
		exerciseDone = false
		set_physics_process(true)
	else:
		isWorking = false
		button.text = "Start Set"
		set_physics_process(false)
		print(get_time_formatted())
		reset_stopwatch()
		currentExercise += 1
		

func play_countdown() -> void:
	countdown.visible = true
	countdown.text = "%d" % (maxTime - seconds)
	button.disabled = true
	if (maxTime - seconds <= -1):
		countdown.visible = false
		button.disabled = false
		time = 0
		exerciseDone = true
		return
	if (maxTime - seconds <= 0):
		countdown.text = "%s" % "Go!"

func start_rest_timer() -> void:
	pass

func reset_stopwatch() -> void:
	time = 0.0
	minutes = 0
	seconds = 0
	mseconds = 0
	minutesLabel.text = "00:"
	secondsLabel.text = "00."
	msecondsLabel.text = "00"

func get_time_formatted() -> String:
	return "%02d:%02d.%02d" % [minutes, seconds, mseconds]
