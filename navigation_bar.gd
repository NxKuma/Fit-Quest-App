extends MarginContainer

@onready var workout_button: Button = $"Buttons/Workout Button"
@onready var tutorial_button: Button = $"Buttons/Tutorial Button"
@onready var home_button: Button = $"Buttons/Home Button"
@onready var guilds_button: Button = $"Buttons/Guilds Button"
@onready var profile_button: Button = $"Buttons/Profile Button"

@export var workout_view: PackedScene
@export var tutorial_view: PackedScene
@export var home_view: PackedScene
@export var guilds_view: PackedScene
@export var profile_view: PackedScene

func _ready():
	connectButton(workout_button, workout_view)
	connectButton(tutorial_button, tutorial_view)
	connectButton(home_button, home_view)
	connectButton(guilds_button, guilds_view)
	connectButton(profile_button, profile_view)

func connectButton(button: Button, scene: PackedScene):
	button.pressed.connect(changeToScene.bind(scene))

func changeToScene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
