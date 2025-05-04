extends Node

@onready var character_scene = $VSplitContainer/SubViewportContainer/SubViewport/test3

var model 

const blend_shapes = [
	"Arm Size",
	"Belly",
	"Breast Size",
	"Hips",
	"Leg Size",
	"Neck Size",
	"Torso Size"
]

func _ready():
	
	model = character_scene.get_node("Armature/Skeleton3D/Adjustable Mannequin Mesh_001")
	#model.get("blend_shapes/Arm Size")
	#print(model.get_blend_shape_value(4))
	#print(model.mesh.get_blend_shape_name(4))
	#print(model.mesh.get_blend_shape_index("Arm Size"))
	
	#for i in model.get_blend_shape_count():
		#print(i, ": ", model.mesh.get_blend_shape_name(i))
	#model.set_blend_shape_value(0, 2.0)
	
	var sliders_container = $VSplitContainer  
	for shape_name in blend_shapes:
		var slider = sliders_container.get_node_or_null(shape_name)
		if slider:
			slider.min_value = 0.0
			slider.max_value = 1.0
			slider.step = 0.01
			slider.connect("value_changed", _on_slider_value_changed.bind(shape_name))

func _on_slider_value_changed(value: float, blend_shape_name: String):
	var index = model.mesh.get_blend_shape_index(blend_shape_name)
	model.set_blend_shape_value(index, value)
	print(blend_shape_name)
