extends Node3D
class_name Gate

@export var area:Area3D
@export var next_gate_index:int = 0 
@export var next_level_string:String = "stage_0_prelude"
@export var spawn_position_offset: Vector3
@export var gate_direction:GateDirection = GateDirection.UP

enum GateDirection {
	UP = 3,
	DOWN = 0,
	LEFT = 1,
	RIGHT = 2
}

signal player_collided_with_gate(String, int)
var has_been_activated = false

func _process(delta: float) -> void:
	var result: Array[InteractionArea] = []
	if area.get_overlapping_areas().size() > 0 or area.get_overlapping_bodies().size() > 0:
		if has_been_activated: return
		player_collided_with_gate.emit("res://scenes/stages/" + next_level_string+".tscn", next_gate_index, gate_direction)
		has_been_activated = true
		print(name, " activated, sending player to gate ", next_level_string, ", ", next_gate_index)

func get_spawn_position():
	return global_position + spawn_position_offset
