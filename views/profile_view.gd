extends Control

@onready var character_3d: SubViewportContainer = $CircleMask2/Character3D

@onready var username = $Username
@onready var height = $VBoxContainer/Height
@onready var weight = $VBoxContainer/Weight
@onready var bmi = $VBoxContainer/HBoxContainer/BMI
@onready var overweight = $VBoxContainer/HBoxContainer/Overweight
@onready var edit_height_button = $"Edit Height"
@onready var height_input = $"Height Input"
@onready var confirm_height_button = $"Confirm Height"
@onready var weight_input = $"Weight Input"
@onready var confirm_weight_button = $"Confirm Weight"
@onready var edit_weight_button = $"Edit Weight"

var bmi_value := 0.0

func _ready() -> void:
	var anim_player = character_3d.get_node("SubViewport/character_model_scene/AnimationPlayer")
	anim_player.play("Idle")
	
	height_input.hide()
	confirm_height_button.hide()
	weight_input.hide()
	confirm_weight_button.hide()

	edit_height_button.connect("pressed", Callable(self, "_on_edit_height_pressed"))
	confirm_height_button.connect("pressed", Callable(self, "_on_confirm_height_pressed"))

	edit_weight_button.connect("pressed", Callable(self, "_on_edit_weight_pressed"))
	confirm_weight_button.connect("pressed", Callable(self, "_on_confirm_weight_pressed"))

func _process(delta: float) -> void:
	if Global.did_signin and Global.person_data != null:
		var h = Global.person_data.height
		var w = Global.person_data.weight
		bmi_value = w / pow(h / 100.0, 2)

		username = Global.login_info.username
		height.text = "Height: %d" % h
		weight.text = "Weight: %d" % w
		bmi.text = "BMI: %.2f" % bmi_value
		
		_is_overweight()

func _is_overweight():
	if bmi_value < 18.5:
		overweight.text = " (Underweight)"
	elif bmi_value < 25:
		overweight.text = " (Normal)"
	elif bmi_value < 30:
		overweight.text = " (Overweight)"
	else:
		overweight.text = " (Obese)"

func _on_edit_height_pressed():
	height_input.text = str(Global.person_data.height)
	height_input.show()
	confirm_height_button.show()

func _on_confirm_height_pressed():
	var new_height = height_input.text.to_int()
	if new_height > 0:
		Global.person_data.height = new_height
		height_input.hide()
		confirm_height_button.hide()
	else:
		printerr("Invalid height entered.")
		
func _on_edit_weight_pressed():
	weight_input.text = str(Global.person_data.weight)
	weight_input.show()
	confirm_weight_button.show()

func _on_confirm_weight_pressed():
	var new_weight = weight_input.text.to_int()
	if new_weight > 0:
		Global.person_data.weight = new_weight
		weight_input.hide()
		confirm_weight_button.hide()
	else:
		printerr("Invalid weight entered.")
