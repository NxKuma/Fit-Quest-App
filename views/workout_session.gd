extends Control

# Routine logic
var routine: WorkoutRoutine
var currentExercise: int = 0
var timeFinish: Array[String]
var doCountdown: bool = false
var showPopup: bool = true

# For stopwatch mechanic
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var mseconds: int = 0
var maxTime: int = 3

# UI
var title: Label
var exerciseLabel: Label
var setsLabel: Label

var minutesLabel: Label
var secondsLabel: Label
var msecondsLabel: Label
var countdown: Label

var start: Button
var pause: Button
var buttonGroup: HBoxContainer

var infoButton: Button
var infoPopup: PopupPanel
var infoLabel: Label

var donePanel: Panel
var workoutSummary: VBoxContainer

var character_3d: SubViewportContainer
var anim_player: AnimationPlayer
var curr_exercise_name: String

func _ready() -> void:
	load_routine()
	
	# Initialize components
	countdown = $Countdown
	
	title = $Header/Title
	exerciseLabel = $"Header/Exercise Label"
	setsLabel = $Header/SetsAndReps
	
	#avatar = $Avatar

	start = $Panel/Buttons/Start
	pause = $Panel/Buttons/Pause
	buttonGroup = $"Panel/Buttons/Secondary Buttons" 
	
	minutesLabel = $Panel/Stopwatch/Minutes
	secondsLabel = $Panel/Stopwatch/Seconds
	msecondsLabel = $Panel/Stopwatch/Milliseconds
	
	#infoButton = $"Info/Info Button"
	#infoPopup = $"Info/Info Popup"
	#infoLabel = $"Info/Info Popup/MarginContainer/Info Label"
	#infoPopup.hide()
	
	donePanel = $Done
	workoutSummary = $"Done/Workout Summary"
	
	character_3d = $Character3D
	anim_player = character_3d.get_node("SubViewport/character_model_scene/AnimationPlayer")
	
	timeFinish = []
	
	# Setup header
	title.text = routine.routine_name

	anim_player.play("Warming Up")

	if (routine.routine_name == "Rest"):
		countdown.visible = true
		countdown.text = "Rest day\ntoday!"
		exerciseLabel.text = ""
		setsLabel.text = ""
		start.disabled = true
		anim_player.play("Breathing Idle")
	else:
		exerciseLabel.text = routine.exercises[currentExercise].exercise_name
		setsLabel.text = "%d sets of %d" % [routine.exercises[currentExercise].sets, routine.exercises[currentExercise].repetitions]
		countdown.visible = false

	# _physics_process right now is to handle stopwatch. Can migrate to physics_process later
	# if _physics_process is needed for workout session logic 
	set_physics_process(false)
  
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

func play_countdown() -> void:
	countdown.visible = true
	if (showPopup):
		countdown.text = "%d" % (maxTime - seconds)
	else:
		countdown.text = "Done!"
	if (maxTime - seconds <= -1):
		countdown.visible = false
		pause.visible = true
		time = 0
		doCountdown = false
		if (!showPopup):
			show_summary()
		else:
			anim_player.play(routine.exercises[currentExercise].exercise_name)
		
	if (maxTime - seconds <= 0 and showPopup):
		countdown.text = "%s" % "Go!"

func start_set() -> void:
	doCountdown = true
	showPopup = true
	set_physics_process(true)
	start.visible = false

func pause_set() -> void:
	anim_player.play("Breathing Idle")
	set_physics_process(false)
	pause.visible = false
	buttonGroup.visible = true

func resume_set() -> void:
	anim_player.play(routine.exercises[currentExercise].exercise_name)
	set_physics_process(true)
	buttonGroup.visible = false
	pause.visible = true

func finish_set() -> void:
	anim_player.play("Breathing Idle")
	timeFinish.append(get_time_formatted())
	currentExercise += 1
	reset_stopwatch()
	buttonGroup.visible = false
	if (currentExercise >= routine.exercises.size()):
		set_physics_process(true)
		showPopup = false
		doCountdown = true
	else:
		exerciseLabel.text = routine.exercises[currentExercise].exercise_name
		setsLabel.text = "%d sets of %d" % [routine.exercises[currentExercise].sets, routine.exercises[currentExercise].repetitions]
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

func show_summary():
	title.text = "Workout Summary"
	exerciseLabel.text = ""
	setsLabel.text = ""
	donePanel.visible = true
	set_physics_process(false)
	var i: int = 0
	for exercise in routine.exercises:
		var label = Label.new()
		label.text = "%s - %s" % [exercise.exercise_name, timeFinish[i]]
		label.add_theme_font_size_override("font_size", 25)
		workoutSummary.add_child(label)
		i += 1

func _on_start_pressed() -> void:
	start_set()

func _on_pause_pressed() -> void:
	pause_set()

func _on_resume_pressed() -> void:
	resume_set()

func _on_finish_pressed() -> void:
	finish_set()

func reset_workout_view():
	for c in workoutSummary.get_children():
		workoutSummary.remove_child(c)
		c.queue_free()
	timeFinish.clear()
	currentExercise = 0
	donePanel.visible = false
	start.visible = true
	pause.visible = false
	buttonGroup.visible = false
	reset_stopwatch()
	_ready()

func _on_reset_workout_pressed() -> void:
	reset_workout_view()

func confirm_workout():
	for c in workoutSummary.get_children():
		workoutSummary.remove_child(c)
		c.queue_free()
	Global.workout_data = timeFinish
	Global.finish_workout_today()
	timeFinish.clear()
	donePanel.visible = false
	title.text = "Workout Done"
	start.visible = true
	pause.visible = false
	buttonGroup.visible = false
	start.disabled = true
	anim_player.play("Breathing Idle")

func _on_confirm_workout_pressed() -> void:
	confirm_workout()
#func _get_anim_name(exercise_name: String) -> String :
	#match exercise_name:
		#"Idle":
			#return "Breathing Idle"
		#"Bicep Curls":
			#return "Bicep Curl"
		#"Jogging":
			#return "Jogging"
		#"Plank":
			#return "Plank"
		#"Push-Ups":
			#return "Push-up"
		#"Squats":
			#return "Back Squat"
		#"Warm Up":
			#return "Warming Up"
		#"Jumping Jacks":
			#return "Jumping Jacks"
		#"Lat Pulldown":
			#return "Front-Raises"
	#return ""


#func _on_info_button_toggled(toggled_on: bool) -> void:
	#if infoPopup.visible:
		#infoPopup.hide()
	#else:
		#_show_info_popup()

#func _show_info_popup():
	#var content = "Here’s a description of the exercise. It can be arbitrarily long and will wrap appropriately."
	#infoLabel.text = content
#
	#infoLabel.rect_min_size = Vector2()  # reset
	#infoLabel.queue_sort()               # ensure layout recalculates
#
	#var min_size = infoLabel.get_minimum_size()
#
	#var padding = Vector2(20, 20)
	#infoPopup.rect_size = min_size + padding
	#var btn_global = infoButton.get_global_position()
	#infoPopup.rect_global_position = btn_global + Vector2(0, infoButton.rect_size.y + 10)
#
	#infoPopup.popup()  # shows the popup
