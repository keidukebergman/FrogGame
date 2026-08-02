class_name Level extends Node3D

enum LevelType {
	None,
	Cinematic,
	Playable
}

@export var level_type: LevelType = LevelType.Playable

@export var camera_default_position:Vector3 = Vector3.ZERO
@export var camera_minimum_position:Vector3 = Vector3.ZERO
@export var camera_maximum_position:Vector3 = Vector3.ZERO



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
