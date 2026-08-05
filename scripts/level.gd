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

@export var gates: Array[Gate]

signal request_level_switch 

func initiate_level ():
	print("Level initiating")
	for gate in gates:
		gate.player_collided_with_gate.connect(on_gate_activated)

func on_gate_activated(level, gate, direction):
	request_level_switch.emit(level, gate, direction)

func get_gate_spawn_position(index:int):
	return gates[index].get_spawn_position()
