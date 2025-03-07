extends MarginContainer

@export var home_view: PackedScene
@export var workout_view: PackedScene
@export var guilds_view: PackedScene
@export var tutorial_view: PackedScene
@export var profile_view: PackedScene


func connectButton(button: Button, scene: PackedScene):
	button.pressed.connect(changeToScene(scene))

func changeToScene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
