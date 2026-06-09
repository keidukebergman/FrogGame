extends Node3D
class_name ProjectileKnockbackManager

@export var body:PhysicsBody3D

func _ready() -> void:
	get_parent().took_knockback.connect(on_take_knockback)

func on_take_knockback (force:Vector3) -> void:
	var current_velocity:Vector3 = body.linear_velocity
	body.linear_velocity = force.normalized() * current_velocity.length() * 2
