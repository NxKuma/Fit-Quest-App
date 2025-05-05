extends SubViewportContainer


@onready var character_model_scene: Node3D = $SubViewport/character_model_scene
@onready var animation_player: AnimationPlayer = $SubViewport/character_model_scene/AnimationPlayer

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_tree().get_current_scene()
	print(parent.get_name() + " hy")
	#if Global.current_scene.get_name() == "Home View":
		#animation_player.play("Breathing Idle")
		#if animation_player.is_playing():
			#print("Penis")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
