extends Control


@onready var day_of_the_week: Label = $"Side Panel Margin/Side Panels/VBoxContainer/MarginContainer/HSplitContainer/Day of the Week"
@onready var streak: RichTextLabel = $"Side Panel Margin/Side Panels/VBoxContainer/MarginContainer/HSplitContainer/Streak"
@onready var routine_of_the__day: Label = $"Side Panel Margin/Side Panels/VBoxContainer/Panel/VSplitContainer/MarginContainer2/HSplitContainer/Routine of the  Day"
@onready var target_muscle: Label = $"Side Panel Margin/Side Panels/VBoxContainer/Panel2/VSplitContainer/MarginContainer2/HSplitContainer/Target Muscle"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
