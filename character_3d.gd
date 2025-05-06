extends SubViewportContainer


@onready var character_model_scene: Node3D = $SubViewport/character_model_scene
@onready var animation_player: AnimationPlayer = $SubViewport/character_model_scene/AnimationPlayer
@onready var character_model_mesh: MeshInstance3D = $SubViewport/character_model_scene/Armature/Skeleton3D/character_model_mesh

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.change_character.connect(change_character)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func change_character(arms: float, neck: float, breast: float, torso: float, belly: float, legs:float, hips: float):
	character_model_mesh.set_blend_shape_value(0,arms)
	character_model_mesh.set_blend_shape_value(1,belly)
	character_model_mesh.set_blend_shape_value(2,breast)
	character_model_mesh.set_blend_shape_value(3,torso)
	character_model_mesh.set_blend_shape_value(4,hips)
	character_model_mesh.set_blend_shape_value(5,legs)
	character_model_mesh.set_blend_shape_value(6,neck)
