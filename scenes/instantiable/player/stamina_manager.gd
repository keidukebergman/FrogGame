extends Node3D
class_name StaminaManager

@export var max_stamina:int = 1
var stamina:float = 0
var stamina_int:int = 0
@export var stamina_recovery_per_second:float = 0.3

signal used_stamina(amount, current_stamina)
signal regained_stamina(amount, current_stamina)
signal maxed_stamina
signal depleted_stamina

func _ready() -> void:
	stamina = max_stamina

func _process(delta: float) -> void:
	stamina += stamina_recovery_per_second * delta
	if floor(stamina) > stamina_int:
		stamina_int = floor(stamina)
		regained_stamina.emit(1, stamina_int)
		if stamina > max_stamina:
			maxed_stamina.emit
			stamina = max_stamina
			stamina_int = max_stamina

func use_stamina (amount:int) -> bool:
	if stamina_int >= amount:
		stamina_int -= amount
		stamina = stamina_int
		used_stamina.emit(amount, stamina_int)
		if stamina_int == 0:
			depleted_stamina.emit()
		return true
	return false
