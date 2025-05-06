extends Control


@onready var day_of_the_week: Label = $"Day of the Week"

@onready var routine_of_the_day: Label = $"Routine of the Day"
@onready var target_muscle: Label = $"Target Muscle"
@onready var character_3d: SubViewportContainer = $Character3D
@onready var streak: Label = $Streak


var time = Time.get_date_dict_from_system()
var days_abv = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	day_of_the_week.set_text(days_abv[time.weekday])
	var routine_name = Global.routine_today.routine_name
	var routine_target = Global.routine_today.routine_description.erase(0, 8)

	routine_of_the_day.set_text(routine_name.to_upper())
	target_muscle.set_text(routine_target.to_upper())
	
	var anim_player = character_3d.get_node("SubViewport/character_model_scene/AnimationPlayer")
	anim_player.play("Breathing Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Global.person_data.streak_days)
	if Global.did_setup or Global.did_signin:
		streak.text = str(Global.person_data.streak_days)
