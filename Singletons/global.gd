extends Node
class_name SceneSwitcher

var current_scene = null
var info_id: int = -1
var person_id: int = -1
var avatar_id: int = -1
var alr_run: bool = false

@export var databaseManager: Node
@export var loginManager: Node


var did_setup = false
	
var avatar_params: AvatarParam
var person_data: PersonData
var guild_data: GuildData
var login_info: LoginInfo
var data_transporter

func _ready():
	var root = get_tree().root
	
	# Get the child at the end
	current_scene = root.get_child(-1)
	avatar_params = AvatarParam.new()
	person_data = PersonData.new()
	guild_data = GuildData.new()
	login_info = LoginInfo.new()
	
	login_info.username = "thanie"
	login_info.password = "thanie"
	
	person_data.height = 169
	person_data.weight = 70
	person_data.login_id = 1
	
	person_id = 1
	
	avatar_params.shoulders = 1
	avatar_params.arms = 1.1
	avatar_params.breasts = 1.2
	avatar_params.torso = 1.3
	avatar_params.belly = 1.4
	avatar_params.hips = 1.5
	avatar_params.legs = 1.6
	avatar_params.neck = 1.7
	
	
	
func _add_info_to_database():
	data_transporter.login_info = login_info
	
	data_transporter._add_user()
	pass
	
func _add_person_to_database():
	data_transporter.person_data = person_data
	data_transporter._add_person()
	pass

func _add_avatar_to_database():
	data_transporter.avatar_params = avatar_params
	data_transporter._add_avatar()
	pass

func _setup_user(username: String, password: String) -> bool:
	var completed: bool = data_transporter._setup_user(username, password)
	return completed

# Make sure this is always run on login and signin before calling _execute_login() and _complete_signin() respectively
func _change_login_info(username: String, password: String):
	login_info.username = username
	login_info.password = password

# Make sure this is always run on signin before calling _complete_signin()
func _change_avatar_info(shoulder: float, arms: float, breasts: float, torso: float, belly: float, hips: float, legs: float, neck: float):
	avatar_params.shoulder = shoulder
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
	_add_info_to_database()
	_add_person_to_database()
	_add_avatar_to_database()
	var completed_setup: bool = _setup_user(login_info.username, login_info.password)
	return completed_setup

func _execute_login() -> bool:
	return _setup_user(login_info.username, login_info.password)

func _process(delta):
	if get_tree() != null and !did_setup:
		data_transporter = get_tree().get_first_node_in_group("DataTransporter")

	if data_transporter != null and !alr_run:
		if data_transporter.did_setup:
			_add_info_to_database()
			_add_person_to_database()
			_add_avatar_to_database()
			var completed_setup: bool = _setup_user(login_info.username, login_info.password)
			alr_run = true
			
	# print("Shoulders: ", avatar_params.shoulders)
	# print("Arms: ", avatar_params.arms)
	# print("Breasts: ", avatar_params.breasts)
	# print("Torso: ", avatar_params.torso)
	# print("Belly: ", avatar_params.belly)
	# print("Hips: ", avatar_params.hips)
	# print("Legs: ", avatar_params.legs)
	# print("Neck: ", avatar_params.neck)

	# print("Person ID: ", person_data.person_id)
	# print("Height: ", person_data.height)
	# print("Weight: ", person_data.weight)
	# print("BMI: ", person_data.bmi)
	pass

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
	
	
