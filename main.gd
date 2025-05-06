extends Control

@export var initialView := 2

@onready var views: Control = %Views
@onready var buttons: HBoxContainer = %Buttons

func _ready():
	_set_page(initialView)
	
	for button in buttons.get_children():
		var buttonIndex = button.get_index()
		button.pressed.connect(_set_page.bind(buttonIndex))

func _set_page(viewNumber):
	#print(viewNumber)
	for i in views.get_child_count():
		views.get_children()[i].visible = (i == viewNumber) # set visible if i == viewNumber
		
