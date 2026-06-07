extends Area3D
class_name Hurtbox

var is_active: bool = false
signal took_damage
signal received_effects

func _ready() -> void:
	pass
	
func verify_hit() -> bool:
	return true
	
func apply_damage(damage) -> void:
	took_damage.emit(damage);

func apply_effects(effects) -> void:
	received_effects.emit(effects)
