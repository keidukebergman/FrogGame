class_name Level extends Node3D

enum LevelType {
	None,
	Cinematic,
	Playable
}

@export var level_type: LevelType = LevelType.Playable

@export var camera_default_position:Vector2 = Vector2.ZERO
@export var camera_minimum_position:Vector2 = Vector2.ZERO
@export var camera_maximum_position:Vector2 = Vector2.ZERO
