extends Node

@onready var character_scene = $VSplitContainer/Character3D/SubViewport/character_model_scene
@onready var sliders_container = $VSplitContainer/Panel/MarginContainer/VBoxContainer

var slider_array = []

var model 

const blend_shapes = [
	"Arm Size",
	"Belly Size",
	"Breast Size",
	"Head Style",
	"Hips Size",
	"Leg Size",
	"Neck Size",
	"Torso Size"
]

func _ready():
	
	#model = character_scene.get_node("Armature/Skeleton3D/Adjustable Mannequin Mesh_001")
	model = character_scene.get_child(0).get_child(0).get_child(0)
	#model.get("blend_shapes/Arm Size")
	#print(model.get_blend_shape_value(4))
	#print(model.mesh.SurfaceGetBlendShapeArrays(1, 1))
	
	#for i in model.get_blend_shape_count():
		#print(i, ": ", model.mesh.get_blend_shape_name(i))
	#model.set_blend_shape_value(0, 2.0)
	
	
	for hsplit in sliders_container.get_children():
		if hsplit is HSplitContainer:
			for vsplit in hsplit.get_children():
				slider_array.append(vsplit.get_child(1))
	
	for n in blend_shapes.size():
		var slider = slider_array[n]
		slider.connect("value_changed", _on_neck_size_value_changed.bind(n))
		print(blend_shapes[n])
		
		for m in blend_shapes.size():
			if blend_shapes[m].contains(slider.get_name()) :
				slider.min_value = 0.0
				slider.max_value = 1.0
				slider.set_step(0.01)
			

func _on_slider_value_changed(value: float, blend_shape: String):
	##var index = model.mesh.get_blend_shape_index(blend_shape_name)
	#model.set_blend_shape_value(blend_shape_index, value)
	##print(blend_shape_name)
	pass



func _on_neck_size_value_changed(value: float, extra_arg_0: int) -> void:
	model.set_blend_shape_value(extra_arg_0, value)


func _on_button_pressed() -> void:
	#print(slider_array[0].get_value())
	Global.avatar_params.arms = slider_array[0].get_value()
	Global.avatar_params.neck = slider_array[1].get_value()
	Global.avatar_params.breasts = slider_array[2].get_value()
	Global.avatar_params.torso = slider_array[3].get_value()
	Global.avatar_params.legs = slider_array[4].get_value()
	Global.avatar_params.hips = slider_array[5].get_value()
	Global.avatar_params.belly = slider_array[6].get_value()
	
