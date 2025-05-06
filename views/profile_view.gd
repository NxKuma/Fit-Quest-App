extends Control

@onready var character_3d: SubViewportContainer = $CircleMask2/Character3D

var height
var weight
var bmi

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim_player = character_3d.get_node("SubViewport/character_model_scene/AnimationPlayer")
	anim_player.play("Idle")
	
	height = $VBoxContainer/Height
	weight = $VBoxContainer/Weight
	bmi = $VBoxContainer/BMI

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.did_signin:
		height.text = "Height: %d" % [Global.person_data.height]
		weight.text = "Weight: %d" % [Global.person_data.weight]
		bmi.text = "BMI: %d" % [Global.person_data.bmi]
