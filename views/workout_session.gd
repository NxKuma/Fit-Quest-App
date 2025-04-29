extends Control

# Routine logic
var exerciseLabel: Label
var routine: WorkoutRoutine
var currentExercise: int = 0
var button: Button
var isWorking: bool = false
var exerciseDone: bool = false

# For stopwatch mechanic
var minutesLabel: Label
var secondsLabel: Label
var countdown: Label
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var maxTime: int = 3

func _ready() -> void:
	exerciseLabel = $"Exercise Container/Exercise Label"
	minutesLabel = $"Exercise Container/Stopwatch/Minutes"
	secondsLabel = $"Exercise Container/Stopwatch/Seconds"
	countdown = $Countdown
	button = $"Exercise Container/StartOrFinish"
	exerciseLabel = $"Exercise Container/Exercise Label"
	
	# Loading the routine resource for now
	routine = preload("res://Workout Routine Resource/Cardio.tres")
	
	# Setting up scene
	exerciseLabel.text = routine.exercises[currentExercise].exercise_name
	countdown.visible = false
	
	# _physics_process right now is to handle stopwatch. Can migrate to physics_process later
	# if _physics_process is needed for workout session logic 
	set_physics_process(false)

func _process(delta: float) -> void:
	exerciseLabel.text = routine.exercises[currentExercise].exercise_name


func _physics_process(delta: float) -> void:
	time += delta
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	if (!exerciseDone):
		play_countdown()
	else:
		minutesLabel.text = "%02d:" % minutes
		secondsLabel.text = "%02d" % seconds

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
		print("countdown done")
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
	minutesLabel.text = "00:"
	secondsLabel.text = "00"

func get_time_formatted() -> String:
	return "%02d:%02d" % [minutes, seconds]
