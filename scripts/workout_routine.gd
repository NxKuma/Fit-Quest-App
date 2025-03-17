extends Resource
class_name workout_routine

@export var exercises: Array[Exercise]
@export var routine_name: String
@export_multiline var routine_description: String

var current_exercises: Array[Exercise] = exercises
signal workout_finished
signal routine_finished

func finish_workout() -> void:
	exercises.pop_front()
	emit_signal("workout_finished")
	if exercises.size() == 0:
		finish_routine()

func finish_routine() -> void:
	emit_signal("routine_finished")
