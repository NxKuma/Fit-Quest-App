extends Node
class_name SceneSwitcher

var current_scene = null
var info_id: int = -1
var person_id: int = -1
var avatar_id: int = -1

@export var databaseManager: Node
@export var loginManager: Node



	
var avatar_params: AvatarParam
var person_data: PersonData

func _ready():
	var root = get_tree().root
	
	# Get the child at the end
	current_scene = root.get_child(-1)
	avatar_params = AvatarParam.new()
	person_data = PersonData.new()
	
	
func _process(delta):
	# print(info_id);
	# print("Shoulders: ", avatar_params.shoulders)
	# print("Arms: ", avatar_params.arms)
	# print("Breasts: ", avatar_params.breasts)
	# print("Torso: ", avatar_params.torso)
	# print("Belly: ", avatar_params.belly)
	# print("Hips: ", avatar_params.hips)
	# print("Legs: ", avatar_params.legs)
	# print("Neck: ", avatar_params.neck)

	print("Person ID: ", person_data.person_id)
	print("Height: ", person_data.height)
	print("Weight: ", person_data.weight)
	print("BMI: ", person_data.bmi)
	
func _goto_scene(path):
	# Used in signal callback, or functions in current scene.
	
	# The point in creating this goto_scene() func is to call the deferred version defined below
	# because the code could still be running when we switch scenes. .call_deferred() waits for the
	# current scene to finish executing code before we run this
	
	# Defer the load to a later time, so we're sure no code is running from current scene.
	
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	# It is now safe to free current scene
	current_scene.free()
	
	# Get new scene
	var s = ResourceLoader.load(path)
	
	#  Instantiate new scene
	current_scene = s.instantiate()
	
	# Add to the current scene as a child of the current one
	get_tree().root.add_child(current_scene)
	
	# Optional (Make it compatible with the SceneTree.change_scene_to_file() API Not sure if we need this but putting it here anyways)
	
	get_tree().current_scene = current_scene
	
	
