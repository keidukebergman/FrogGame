extends Area3D
class_name Hurtbox

var is_active: bool = false
signal took_damage
signal received_attack(data:AttackData)
signal received_effects

func _ready() -> void:
	is_active = true
	pass
	
func verify_hit() -> bool:
	return true
	
func _apply_damage(damage) -> void:
	took_damage.emit(damage);

func apply_attack(attack_data:AttackData) -> void:
	if !is_active:
		return
	_apply_damage(attack_data.damage)
	_apply_effects(attack_data.effects)
	received_attack.emit(attack_data)

func _apply_effects(effects) -> void:
	received_effects.emit(effects)
