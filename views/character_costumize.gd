extends Node

@onready var character_scene = $VSplitContainer/Character3D/SubViewport/character_model_scene
var slider_array = []

var model 

const blend_shapes = [
	"Arm Size",
	"Belly Size",
	"Breast Size",
	"Hips Size",
	"Leg Size",
	"Neck Size",
	"Torso Size",
	"Head Style"
]

signal blend_shape_change

func _ready():
	
	model = character_scene.get_node("Armature/Skeleton3D/Adjustable Mannequin Mesh_001")
	#model.get("blend_shapes/Arm Size")
	#print(model.get_blend_shape_value(4))
	#print(model.mesh.SurfaceGetBlendShapeArrays(1, 1))
	
	#for i in model.get_blend_shape_count():
		#print(i, ": ", model.mesh.get_blend_shape_name(i))
	#model.set_blend_shape_value(0, 2.0)
	
	
	
	
	var sliders_container = $VSplitContainer/Panel/MarginContainer/VBoxContainer
	
	for hsplit in sliders_container.get_children():
		for vsplit in hsplit.get_children():
			slider_array.append(vsplit.get_child(1))
	
	for n in blend_shapes.size():
		
		for m in blend_shapes.size():
			var slider = slider_array[n]
			if blend_shapes[m].contains(slider.get_name()) :
				slider.min_value = 0.0
				slider.max_value = 1.0
				slider.set_step(0.01)
				#slider.connect("value_changed", self ,_on_slider_value_changed.bind(blend_shapes[m]) )

				
				
		#print(slider)
		#if slider:
			#slider.min_value = 0.0
			#slider.max_value = 1.0
			#slider.step = 0.01
			#slider.connect("value_changed", _on_slider_value_changed)
			

func _on_slider_value_changed(value: float, blend_shape: String):
	##var index = model.mesh.get_blend_shape_index(blend_shape_name)
	#model.set_blend_shape_value(blend_shape_index, value)
	##print(blend_shape_name)
	print(blend_shape)
	pass


func _on_neck_size_value_changed(value: float, extra_arg_0: String) -> void:
	model.set_blend_shape_value()
	
