extends Area3D
class_name GroundPoller

var is_grounded:bool = false

func _process(_delta: float) -> void:
	var overlapping_bodies = get_overlapping_bodies()
	is_grounded = overlapping_bodies.size() > 0
