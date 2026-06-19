extends RigidBody3D

@export var projectile_speed = 6
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var basis = get_global_transform().basis
	var forward = basis.z
	linear_velocity = forward * projectile_speed
