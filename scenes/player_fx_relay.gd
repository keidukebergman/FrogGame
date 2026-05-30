extends Node3D
class_name PlayerFXRelay

@export var critical_damage_threshold:float = 30
@export var significant_damage_threshold:float = 5
@export var slow_mo_manager:SlowMoManager
@export var zoom_manager:ZoomInManager

func on_player_took_damage(damage:float) -> void:
	if(damage > critical_damage_threshold):
		return
	if(damage > significant_damage_threshold):
		slow_mo_manager.slow_time(0.1, 0.01)
		zoom_manager.start_zoom_effect(randf_range(0.9, 1.1), 900, 10)
		return
