extends Node3D
class_name UI_Manager

@export var health_bar_manager:HealthBarManager
@export var stamina_marker_manager:StaminaMarkerManager
var stamina_manager:StaminaManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if stamina_manager:
		var stamina = stamina_manager.stamina_int
		var stamina_fraction = stamina_manager.stamina - stamina
		stamina_marker_manager.update_stamina(stamina, stamina_fraction)

func _on_player_health_change(damaged:bool, current_health:float):
	health_bar_manager.on_health_changed(damaged, current_health)

func _on_player_health_depleted():
	pass

func _on_player_stamina_change():
	pass
