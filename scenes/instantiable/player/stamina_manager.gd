extends Node3D
class_name StaminaManager

@export var max_stamina:int = 1
var stamina:float = 0
@export var stamina_recovery_per_second:float = 0.3

func _ready() -> void:
	stamina = max_stamina

func _process(delta: float) -> void:
	stamina += stamina_recovery_per_second * delta
	if stamina > max_stamina:
		stamina = max_stamina

func use_stamina (amount:int) -> bool:
	if stamina >= amount:
		stamina -= amount
		return true
	return false
