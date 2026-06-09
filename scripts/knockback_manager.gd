extends Node3D
class_name KnockbackHandler

@export var body:PhysicsBody3D

func _ready() -> void:
	get_parent().took_knockback.connect(on_take_knockback)

func on_take_knockback (force:Vector3) -> void:
	var current_velocity:Vector3 = body.velocity;
	var mass:float = body.mass;
	var target_velocity:Vector3 = force/mass
	var diff:Vector3 = target_velocity - current_velocity
	var diff_vector:Vector3 = diff.normalized()
	var diff_magnitude:float = diff.length()
	var diff_force:float = clamp(diff_magnitude*mass, 0, force.length());
	var force_to_add;
	force_to_add = diff_vector * diff_force;
	body.add_force(force_to_add)
