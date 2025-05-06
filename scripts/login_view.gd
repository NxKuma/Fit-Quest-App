extends Control

var username_field
var password_field

var can_login: bool = true
var username: String
var password: String

var anim_player
var splash_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	username_field = $Login/VBoxContainer/Username
	password_field = $Login/VBoxContainer/Password
	
	#if !Global.is_splash_screen_done:
	anim_player = $SplashScreen/AnimationPlayer
	splash_screen = $SplashScreen
	anim_player.play("splash_fade")
	await anim_player.animation_finished
	Global.splash_screen_done()
	splash_screen.visible = false

func to_main():
	username = username_field.text
	password = password_field.text
	# try login
	if(can_login):
		get_tree().change_scene_to_file("res://main.tscn")

func to_sign_up():
	get_tree().change_scene_to_file("res://views/sign_in_view.tscn")

func _on_login_button_pressed() -> void:
	to_main()

func _on_to_signup_pressed() -> void:
	to_sign_up()
