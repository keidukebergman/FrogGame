extends Node3D
class_name PlayerFXRelay

@export var critical_damage_threshold:float = 30
@export var significant_damage_threshold:float = 5
@export var slow_mo_manager:SlowMoManager
@export var zoom_manager:ZoomInManager
@export var shake_manager:CameraShakeManager

func on_player_took_damage(damage:float) -> void:
	if(damage > critical_damage_threshold):
		return
	if(damage > significant_damage_threshold):
		slow_mo_manager.slow_time(0.1, 0.001)
		zoom_manager.start_zoom_effect(randf_range(0.98, 0.99), 900, 10)
		shake_manager.start_shake_effect(1, 0.8, Vector3(randf_range(-0.1, 0.1), 0.001, randf_range(-0.1, 0.1)).normalized())
		return
