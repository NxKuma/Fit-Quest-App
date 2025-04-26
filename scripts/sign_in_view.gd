extends Control

@onready var button: Button = $MarginContainer/VSplitContainer/VSplitContainer/Button
@onready var username: LineEdit = $MarginContainer/VSplitContainer/Name
@onready var password: LineEdit = $MarginContainer/VSplitContainer/VSplitContainer/VSplitContainer2/Password
@onready var weight: LineEdit = $MarginContainer/VSplitContainer/VSplitContainer/VSplitContainer2/VSplitContainer/Weight
@onready var height: LineEdit = $MarginContainer/VSplitContainer/VSplitContainer/VSplitContainer2/VSplitContainer/Height


var is_completed: bool = true

var signin_username: String
var signin_password: String
var signin_weight: float
var signin_height: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(to_login)
	
func to_login():
	if(is_completed):
		get_tree().change_scene_to_file("res://views/login_view.tscn")
