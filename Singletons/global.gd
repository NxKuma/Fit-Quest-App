extends Node
class_name SceneSwitcher

var current_scene = null
var user_id: int = -1

signal change_character(arms: float, neck: float, breast: float, torso: float, belly: float, legs:float, hips: float)

@export var databaseManager: Node
@export var loginManager: Node

class AvatarParams:
	var shoulders: float = 0
	var arms: float = 0
	var breasts: float = 0
	var torso: float = 0
	var belly: float = 0
	var hips: float = 0
	var legs: float = 0
	var neck: float = 0
		
	
var avatar_params: AvatarParams
var character_changed: bool = false

var day: int
var workout_plan: WeeklyWorkoutPlan
var routine_today: WorkoutRoutine

func _ready():
	avatar_params = AvatarParams.new()
	
	var root = get_tree().root
	
	# Get the child at the end
	current_scene = root.get_child(-1)
	
	# For workout plan logic
	workout_plan = preload("res://Weekly Routine Resource/WeightTraining.tres")
	day = Time.get_datetime_dict_from_system()["weekday"]
	routine_today = workout_plan.get_workout_today(day)

func get_routine_today():
	return routine_today

func _process(delta):
	#print(user_id);
	pass
	
	# For workout plan logic
	workout_plan = preload("res://Weekly Routine Resource/WeightTraining.tres")
	day = Time.get_datetime_dict_from_system()["weekday"]
	routine_today = workout_plan.get_workout_today(day)
	
	if character_changed:
		change_character.emit(avatar_params.arms, avatar_params.neck, avatar_params.breasts, avatar_params.torso, avatar_params.belly, avatar_params.legs, avatar_params.hips)


	#Global.change_character.emit(arms, neck, breast, torso, belly, legs, hips)

func _goto_scene(path):
	# Used in signal callback, or functions in current scene.
	
	# The point in creating this goto_scene() func is to call the deferred version defined below
	# because the code could still be running when we switch scenes. .call_deferred() waits for the
	# current scene to finish executing code before we run this
	
	# Defer the load to a later time, so we're sure no code is running from current scene.
	
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	# It is now safe to free current scene
	current_scene.free()
	
	# Get new scene
	var s = ResourceLoader.load(path)
	
	#  Instantiate new scene
	current_scene = s.instantiate()
	
	# Add to the current scene as a child of the current one
	get_tree().root.add_child(current_scene)
	
	# Optional (Make it compatible with the SceneTree.change_scene_to_file() API Not sure if we need this but putting it here anyways)
	
	get_tree().current_scene = current_scene

func get_routine():
	pass
	
