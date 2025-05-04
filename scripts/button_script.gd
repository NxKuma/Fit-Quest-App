extends Node
class_name ButtonScript

@export var next_path: String = ""

func _on_pressed():
	Global._goto_scene(next_path)
