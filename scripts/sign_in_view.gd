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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	username_field = $Login/VBoxContainer/Username
	password_field = $Login/VBoxContainer/Password
	height_field = $Login/VBoxContainer/HBoxContainer/Height
	weight_field = $Login/VBoxContainer/HBoxContainer/Weight

func do_signup():
	signin_username = username_field.text
	signin_password = password_field.text
	signin_height = height_field.text.to_float()
	signin_weight = weight_field.text.to_float()
	# check if valid
	if can_signup:
		get_tree().change_scene_to_file("res://main.tscn")

func to_login():
	get_tree().change_scene_to_file("res://views/login_view.tscn")

func _on_signup_button_pressed() -> void:
	do_signup()
	
func _on_to_login_pressed() -> void:
	to_login()
