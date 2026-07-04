extends Node3D
class_name ProjectileCollisionMaskInverter

@export var hitbox:Hitbox

func _ready() -> void:
	get_parent().took_knockback.connect(on_take_knockback)

func on_take_knockback (force:Vector3) -> void: #TODO: IMPROVE!!!
	if (hitbox.collision_mask == 16):
		hitbox.collision_mask = 32
	elif (hitbox.collision_mask == 32):
		hitbox.collision_mask = 16
