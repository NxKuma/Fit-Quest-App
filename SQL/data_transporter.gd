extends Node
class_name DataTransporter

var alr_run: bool

# Avatar Param Data
var shoulders: float
var arms: float
var breasts: float
var torso: float
var belly: float
var hips: float
var legs: float
var neck: float



# Called when the node enters the scene tree for the first time.
func _ready():
	alr_run = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process_avatar_data() -> void:
	Global.avatar_params.shoulders = shoulders
	Global.avatar_params.arms = arms
	Global.avatar_params.breasts = breasts
	Global.avatar_params.torso = torso
	Global.avatar_params.belly = belly
	Global.avatar_params.hips = hips
	Global.avatar_params.legs = legs
	Global.avatar_params.neck = neck
