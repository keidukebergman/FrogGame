extends Node3D
class_name UI_Manager

@export var health_bar_manager:HealthBarManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_health_change(damaged:bool, current_health:float):
	health_bar_manager.on_health_changed(damaged, current_health)

func _on_player_health_depleted():
	pass
