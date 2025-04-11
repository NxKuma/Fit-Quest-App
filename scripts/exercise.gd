extends Resource
class_name Exercise

@export var exercise_name: String
@export var sets: int
@export var repetitions: int
@export_multiline var exercise_description: String

var is_done: bool
var current_reps: int = repetitions
var current_sets: int = sets

signal did_rep
signal did_set
signal finished_exercise

func do_rep() -> void:
	current_reps -= 1
	emit_signal("did_rep")
	
	if repetitions == 0:
		do_set()
	
func do_set() -> void:
	current_sets -= 1
	emit_signal("did_set")
	
	current_reps = repetitions
	if current_sets == 0:
		finish_exercise()
		
func finish_exercise():
	emit_signal("finished_exercise")
	
