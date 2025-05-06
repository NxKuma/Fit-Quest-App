extends Node
class_name SceneSwitcher

var current_scene = null
var info_id: int = -1
var person_id: int = -1
var avatar_id: int = -1
var alr_run: bool = false


signal change_character(arms: float, neck: float, breast: float, torso: float, legs:float, hips: float, belly: float)

@export var databaseManager: Node
@export var loginManager: Node


var did_setup = false
var can_load = false
var did_signin = false
	
var avatar_params: AvatarParam
var person_data: PersonData
var guild_data: GuildData
var login_info: LoginInfo
var data_transporter
var character_changed: bool = false

var workout_plan: WeeklyWorkoutPlan
var routine_today: WorkoutRoutine
var workout_data: Array[String]
var is_workout_finished_today: bool = false

var is_splash_screen_done: bool = false

var all_guild_data: Array[GuildData]

func _ready():
	avatar_params = AvatarParam.new()
	
	var root = get_tree().root
	
	# Get the child at the end
	current_scene = root.get_child(-1)
	avatar_params = AvatarParam.new()
	person_data = PersonData.new()
	guild_data = GuildData.new()
	login_info = LoginInfo.new()
	
	# For workout plan logic
	workout_plan = preload("res://Weekly Routine Resource/WeightTraining.tres")
	var day = Time.get_datetime_dict_from_system()["weekday"]
	routine_today = workout_plan.get_workout_today(day)
	

func _add_info_to_database():
	data_transporter.login_info = login_info
	return data_transporter._add_user()
	
func _add_person_to_database():
	data_transporter.person_data = person_data
	return data_transporter._add_person()

func _add_avatar_to_database():
	data_transporter.avatar_params = avatar_params
	return data_transporter._add_avatar()

func _change_height(height: float):
	data_transporter.change_height(height)

func _change_weight(weight: float):
	data_transporter.change_weight(weight)

func _add_workout(workout_name: String):
	data_transporter.add_workout(workout_name)

func _setup_user(username: String, password: String) -> bool:
	var completed: bool = data_transporter._setup_user(username, password)
	return completed

# Make sure this is always run on login and signin before calling _execute_login() and _complete_signin() respectively
func _change_login_info(username: String, password: String):
	login_info.username = username
	login_info.password = password

# Make sure this is always run on signin before calling _complete_signin()
func _change_avatar_info(arms: float, breasts: float, torso: float, belly: float, hips: float, legs: float, neck: float):
	avatar_params.arms = arms
	avatar_params.breasts = breasts
	avatar_params.torso = torso
	avatar_params.belly = belly
	avatar_params.hips = hips
	avatar_params.legs = legs
	avatar_params.neck = neck

# Make sure this is always run on signin before calling _complete_signin()
func _change_person_info(height: float, weight: float, bmi: float):
	person_data.height = height
	person_data.weight = weight
	person_data.bmi = bmi
	
func _complete_signin() -> bool:
	print("SURE: " + login_info.username + " " + login_info.password)
	info_id = _add_info_to_database()
	person_id = _add_person_to_database()
	_add_avatar_to_database()
	var completed_setup: bool = _setup_user(login_info.username, login_info.password)
	return completed_setup



func _execute_login() -> bool:
	return _setup_user(login_info.username, login_info.password)

func _process(delta):
	#print(can_load)
	
	if get_tree() != null and !did_setup and can_load and get_tree().current_scene != null:
		if get_tree().current_scene.name == "Main":
			data_transporter = get_tree().get_first_node_in_group("DataTransporter")
			did_setup = true
		
	if get_tree() != null and !alr_run and did_setup and did_signin:
		alr_run = true
		_complete_signin()
	
	if character_changed:
		change_character.emit(avatar_params.arms, avatar_params.neck, avatar_params.breasts, avatar_params.torso, avatar_params.belly, avatar_params.legs, avatar_params.hips)


func get_routine_today():
	return routine_today

func finish_workout_today():
	is_workout_finished_today = true
  
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

func splash_screen_done():
	is_splash_screen_done = true
	#print("splash done!")
