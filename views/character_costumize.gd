extends Node
@onready var character_3d: SubViewportContainer = $VSplitContainer/Character3D
@onready var character_scene = character_3d.get_node("SubViewport/character_model_scene")
@onready var sliders_container = $VSplitContainer/Panel/MarginContainer/VBoxContainer

var slider_array = []

var model 

const blend_shapes = [
	"Arm Size",
	"Neck Size",
	"Breast Size",
	"Torso Size",
	"Leg Size",
	"Hips Size",
	"Belly Size",
	"Head Style"
]

func _ready():
	
	#model = character_scene.get_node("Armature/Skeleton3D/Adjustable Mannequin Mesh_001")
	model = character_scene.get_child(0).get_child(0).get_child(0)
	#model.get("blend_shapes/Arm Size")
	#print(model.get_blend_shape_value(4))
	#print(model.mesh.SurfaceGetBlendShapeArrays(1, 1))
	
	
	#for i in model.get_blend_shape_count():
		#print(i, ": ", model.mesh.get_blend_shape_name(i))
	
	for hsplit in sliders_container.get_children():
		if hsplit is HSplitContainer:
			for vsplit in hsplit.get_children():
				#slider_array.append(vsplit.get_child(1))
				var slider = vsplit.get_child(1)
				slider.min_value = 0.0
				slider.max_value = 1.0
				slider.set_step(0.01)
				var index = slider_array.size()  # store index before appending
				slider_array.append(slider)
				slider.connect("value_changed", _on_slider_value_changed.bind(index))
	

	#for n in blend_shapes.size():
		#var slider = slider_array[n]
		#slider.connect("value_changed", _on_neck_size_value_changed.bind(n))
		#print(blend_shapes[n])
		#
		#for m in blend_shapes.size():
			#if blend_shapes[m].contains(slider.get_name()) :
				#slider.min_value = 0.0
				#slider.max_value = 1.0
				#slider.set_step(0.01)


func _on_slider_value_changed(value: float, index: int):
	model.set_blend_shape_value(index, clamp(value, 0.0, 1.0))


func _on_neck_size_value_changed(value: float, extra_arg_0: int) -> void:
	model.set_blend_shape_value(extra_arg_0, value)


func _on_button_pressed() -> void:
	var arms = slider_array[0].get_value()
	var neck = slider_array[1].get_value()
	var breast = slider_array[2].get_value()
	var torso  = slider_array[3].get_value()
	var legs = slider_array[4].get_value()
	var hips = slider_array[5].get_value()
	var belly = slider_array[6].get_value()
	
	Global.avatar_params.arms = arms
	Global.avatar_params.neck = neck
	Global.avatar_params.breasts = breast
	Global.avatar_params.torso = torso
	Global.avatar_params.legs = legs
	Global.avatar_params.hips = hips
	Global.avatar_params.belly = belly
	
	print(arms, neck, breast, torso, legs, hips, belly)
	#Global.change_character.emit(arms, neck, breast, torso, legs, hips, belly)

	Global.character_changed = true
	
	Global.did_signin = true
	get_tree().change_scene_to_file("res://main.tscn")
	#Global._goto_scene("res://main.tscn")
