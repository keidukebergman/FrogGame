extends Node3D
class_name ProjectileDeflectionManager

@export var hitbox:Hitbox

func on_take_attack (attack_data:AttackData) -> void: #TODO: IMPROVE!!!
	if attack_data.attacker.has_meta("Player"):
		hitbox.collision_mask = 32
	else:
		hitbox.collision_mask = 16
