extends Control


@onready var day_of_the_week: Label = $"Side Panel Margin/Side Panels/VBoxContainer/MarginContainer/HSplitContainer/Day of the Week"
@onready var streak: RichTextLabel = $"Side Panel Margin/Side Panels/VBoxContainer/MarginContainer/HSplitContainer/Streak"
@onready var routine_of_the__day: Label = $"Side Panel Margin/Side Panels/VBoxContainer/Panel/VSplitContainer/MarginContainer2/HSplitContainer/Routine of the  Day"
@onready var target_muscle: Label = $"Side Panel Margin/Side Panels/VBoxContainer/Panel2/VSplitContainer/MarginContainer2/HSplitContainer/Target Muscle"
@onready var character_3d: SubViewportContainer = $Character3D


var time = Time.get_date_dict_from_system()
var days_abv = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	day_of_the_week.set_text(days_abv[time.weekday])
	var routine_name = Global.routine_today.routine_name
	var routine_target = Global.routine_today.routine_description.erase(0, 8)
	
	routine_of_the__day.set_text(routine_name.to_upper())
	target_muscle.set_text(routine_target.to_upper())
	
	var anim_player = character_3d.get_node("SubViewport/character_model_scene/AnimationPlayer")
	anim_player.play("Jogging")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
