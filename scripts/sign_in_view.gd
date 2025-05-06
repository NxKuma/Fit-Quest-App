extends Control

var username_field
var password_field
var height_field
var weight_field

var can_signup: bool = false
var signin_username: String
var signin_password: String
var signin_weight: float
var signin_height: float

var error_prompt: Label

var character_customize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.did_setup = false
	username_field = $Signin/VBoxContainer/Username
	password_field = $Signin/VBoxContainer/Password
	height_field = $Signin/VBoxContainer/HBoxContainer/Height
	weight_field = $Signin/VBoxContainer/HBoxContainer/Weight
	
	error_prompt = $Signin/VBoxContainer/Panel2/ErrorPrompt
	
	character_customize = $"Character Customize"

func do_signip():
	signin_username = username_field.text
	signin_password = password_field.text
	var height_text = height_field.text
	var weight_text = weight_field.text
	
	var height_valid = height_text.is_valid_float()
	var weight_valid = weight_text.is_valid_float()
	
	if signin_username.is_empty() or signin_password.is_empty():
		error_prompt.visible = true
		error_prompt.text = "Username and password cannot be empty."
		return

	if not height_valid or not weight_valid:
		error_prompt.visible = true
		error_prompt.text = "Height or weight must not be invalid."
		return

# If valid, convert to float
	var signin_height = height_text.to_float()
	var signin_weight = weight_text.to_float()
	
	print("TEST: " + signin_username + " " + signin_password)
	Global.login_info.username = signin_username
	Global.login_info.password = signin_password
	print("TEST: "+ Global.login_info.username + " " + Global.login_info.password)
	Global.person_data.height = signin_height
	Global.person_data.weight = signin_weight
	
	character_customize.visible = true

func to_login():
	get_tree().change_scene_to_file("res://main.tscn")
	#get_tree().change_scene_to_file("res://views/login_view.tscn")

func _on_signup_button_pressed() -> void:
	do_signip()
	
func _on_to_login_pressed() -> void:
	to_login()
