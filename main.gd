extends Control

@export var initialView := 0

@onready var views: MarginContainer = %Views
@onready var buttons: HBoxContainer = %Buttons

func _ready():
	_set_page(initialView)
	
	for button in buttons.get_children():
		var buttonIndex = button.get_index()
		button.pressed.connect(_set_page.bind(buttonIndex))

func _set_page(viewNumber):
	for i in views.get_child_count():
		views.get_children()[i].visible = i == viewNumber # set visible if i == viewNumber
