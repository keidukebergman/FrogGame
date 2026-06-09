extends Node3D
class_name EffectManager

@export var hurtbox:Hurtbox

signal took_knockback(force:Vector3)

func _ready() -> void:
	hurtbox.received_effects.connect(_handle_effects)

func _handle_effects(effects:Dictionary) -> void:
	for effect in effects:
		match effect:
			"knockback":
				took_knockback.emit(effects[effect])
				pass
