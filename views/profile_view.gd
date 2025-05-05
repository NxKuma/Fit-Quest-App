extends Control

@onready var character_3d: SubViewportContainer = $CircleMask2/Character3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim_player = character_3d.get_node("SubViewport/character_model_scene/AnimationPlayer")
	anim_player.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
