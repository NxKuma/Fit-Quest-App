extends Control

# Routine logic
var routine: WorkoutRoutine
var currentExercise: int = 0
var doCountdown: bool = false

# For stopwatch mechanic
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var mseconds: int = 0
var maxTime: int = 3

# UI
var title: Label
var exerciseLabel: Label

var start: Button
var pause: Button
var buttonGroup: HBoxContainer
var resume: Button
var finish: Button
var minutesLabel: Label
var secondsLabel: Label
var msecondsLabel: Label
var countdown: Label


func _ready() -> void:
	load_routine()
	
	# Initialize components
	title = $Header/Title
	exerciseLabel = $"Header/Exercise Label"
	
	start = $Panel/Buttons/Start
	pause = $Panel/Buttons/Pause
	buttonGroup = $"Panel/Buttons/Secondary Buttons" 
	resume = $"Panel/Buttons/Secondary Buttons/Resume"
	finish = $"Panel/Buttons/Secondary Buttons/Finish"
	
	minutesLabel = $Panel/Stopwatch/Minutes
	secondsLabel = $Panel/Stopwatch/Seconds
	msecondsLabel = $Panel/Stopwatch/Milliseconds
	
	countdown = $Countdown
	
	# Setup header
	title.text = routine.routine_name
	if (routine.routine_name == "Rest"):
		set_process(false)
		countdown.visible = true
		countdown.text = "Rest day\ntoday!"
		exerciseLabel.text = ""
		start.disabled = true
	else:
		exerciseLabel.text = routine.exercises[currentExercise].exercise_name
		countdown.visible = false
	
	# _physics_process right now is to handle stopwatch. Can migrate to physics_process later
	# if _physics_process is needed for workout session logic 
	set_physics_process(false)
	#set_process(false)

#func _process(delta: float) -> void:
	#if (currentExercise >= routine.exercises.size()):
		#countdown.visible = true
		#countdown.text = "Done!"
		#button.disabled = true
		#return
	#exerciseLabel.text = routine.exercises[currentExercise].exercise_name

func _physics_process(delta: float) -> void:
	time += delta
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	mseconds = fmod(time, 1) * 100
	if (doCountdown):
		play_countdown()
	else:
		minutesLabel.text = "%02d:" % minutes
		secondsLabel.text = "%02d." % seconds
		msecondsLabel.text = "%02d" % mseconds

func load_routine():
	routine = Global.get_routine_today()

#func _on_start_or_finish_pressed() -> void:
	#if (!isWorking):
		#isWorking = true
		#button.text = "Finish Set"
		#exerciseDone = false
		#set_physics_process(true)
	#else:
		#isWorking = false
		#button.text = "Start Set"
		#set_physics_process(false)
		#print(get_time_formatted())
		#reset_stopwatch()
		#currentExercise += 1
		#

func play_countdown() -> void:
	countdown.visible = true
	countdown.text = "%d" % (maxTime - seconds)
	if (maxTime - seconds <= -1):
		countdown.visible = false
		pause.visible = true
		time = 0
		print("countdown done")
		doCountdown = false
	if (maxTime - seconds <= 0):
		countdown.text = "%s" % "Go!"

func start_set() -> void:
	doCountdown = true
	set_physics_process(true)
	start.visible = false

func pause_set() -> void:
	set_physics_process(false)
	pause.visible = false
	buttonGroup.visible = true

func resume_set() -> void:
	set_physics_process(true)
	buttonGroup.visible = false
	pause.visible = true

func finish_set() -> void:
	# save timer data
	get_time_formatted()
	reset_stopwatch()
	currentExercise += 1
	buttonGroup.visible = false
	if (currentExercise >= routine.exercises.size()):
		countdown.visible = true
		countdown.text = "Done!"
	else:
		exerciseLabel.text = routine.exercises[currentExercise].exercise_name
		start.visible = true

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


func _on_start_pressed() -> void:
	start_set()


func _on_pause_pressed() -> void:
	pause_set()

func _on_resume_pressed() -> void:
	resume_set()

func _on_finish_pressed() -> void:
	finish_set()
