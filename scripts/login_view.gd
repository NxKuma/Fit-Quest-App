extends Control

@onready var log_in: Button = $MarginContainer/VSplitContainer/VSplitContainer/VSplitContainer/LogIn
@onready var signup: Button = $MarginContainer/VSplitContainer/VSplitContainer/VSplitContainer/Signup

var can_login: bool = true
var username: String
var password: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	log_in.pressed.connect(to_main)
	signup.pressed.connect(to_sign_up)

func to_sign_up():
	get_tree().change_scene_to_file("res://views/sign_in_view.tscn")
	
func to_main():
	if(can_login):
		get_tree().change_scene_to_file("res://main.tscn")
