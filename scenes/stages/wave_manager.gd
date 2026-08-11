extends Node3D
class_name WaveManager

signal request_enemy_spawn (enemy:PackedScene, position:Vector3)
signal request_boss_spawn (boss:PackedScene, position:Vector3)


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func on_wave_cleared() -> void:
	pass
