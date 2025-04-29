extends Resource
class_name WeeklyWorkoutPlan

@export var monday_workout_plan: WorkoutRoutine
@export var tuesday_workout_plan: WorkoutRoutine
@export var wednesday_workout_plan: WorkoutRoutine
@export var thursday_workout_plan: WorkoutRoutine
@export var friday_workout_plan: WorkoutRoutine
@export var saturday_workout_plan: WorkoutRoutine
@export var sunday_workout_plan: WorkoutRoutine
@export_multiline var routine_description: String

signal monday_workout_finished
signal tuesday_workout_finshed
signal wednesday_workout_finished
signal thursday_workout_finshed
signal friday_workout_finished
signal saturday_workout_finshed
signal sunday_workout_finished

func get_workout_today(i: int) -> WorkoutRoutine:
	match i:
		0:
			return sunday_workout_plan
		1:
			return monday_workout_plan
		2:
			return tuesday_workout_plan
		3:
			return wednesday_workout_plan
		4:
			return thursday_workout_plan
		5:
			return friday_workout_plan
		6:
			return saturday_workout_plan
	return

func finish_monday_workout() -> void:
	emit_signal("monday_workout_finished")

func finish_tuesday_workout() -> void:
	emit_signal("tuesday_workout_finished")

func finish_wednesday_workout() -> void:
	emit_signal("wednesday_workout_finished")

func finish_thursday_workout() -> void:
	emit_signal("thursday_workout_finished")

func finish_friday_workout() -> void:
	emit_signal("friday_workout_finished")

func finish_saturday_workout() -> void:
	emit_signal("saturday_workout_finished")

func finish_sunday_workout() -> void:
	emit_signal("sunday_workout_finished")
