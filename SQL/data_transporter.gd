extends Node
class_name DataTransporter



var alr_run: bool
var safe_run: bool
var did_setup: bool = false

@export var login_info_manager: Node
@export var sql_manager: Node

# Avatar Param Data
var arms: float
var breasts: float
var torso: float
var belly: float
var hips: float
var legs: float
var neck: float

var avatar_param

# Person Data
var person_id: int
var height: float
var weight: float
var bmi: float
var guild_id: int

# Login info Data
var username: String
var password: String

var person_data: PersonData
var avatar_params: AvatarParam
var guild_data: GuildData
var login_info: LoginInfo


# Called when the node enters the scene tree for the first time.
func _ready():
	alr_run = false
	username = "test"
	password = "test"
	safe_run = false
	
	person_data = PersonData.new()
	avatar_params = AvatarParam.new()
	guild_data = GuildData.new()
	login_info = LoginInfo.new()
	
	
	pass # Replace with function body.

func _process(delta: float):
	if !did_setup:
		if sql_manager.did_setup:
			did_setup = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _add_user():
	return login_info_manager.add_user(login_info.username, login_info.password)
	
func _add_person():
	login_info_manager.add_person(person_data.height, person_data.weight, person_data.login_id)

func _add_avatar():
	if Global.person_id == -1:
		return
	
	login_info_manager.add_avatar(Global.person_id, avatar_params.arms, avatar_params.breasts, avatar_params.torso, avatar_params.belly, avatar_params.hips, avatar_params.legs, avatar_params.neck)

func _setup_user(username: String, password: String) -> bool:
	var completed: bool = login_info_manager.set_current_user(username, password)
	return completed

func _process_avatar_data():
	Global.avatar_params.arms = arms
	Global.avatar_params.breasts = breasts
	Global.avatar_params.torso = torso
	Global.avatar_params.belly = belly
	Global.avatar_params.hips = hips
	Global.avatar_params.legs = legs
	Global.avatar_params.neck = neck

func _process_person_data():
	Global.person_data.person_id = person_id
	Global.person_data.height = height
	Global.person_data.weight = weight
	Global.person_data.bmi = bmi
	Global.person_data.guild_id = guild_id
	
