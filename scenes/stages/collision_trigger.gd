extends Area3D
class_name CollisionTrigger

signal was_interacted_with()

var has_been_triggered = false
var interactable_type = InteractableObject.InteractableType.Dialogue

func _process(delta: float) -> void:
	var result: Array[InteractionArea] = []
	if has_been_triggered:
		return
	if get_overlapping_areas().size() > 0:
		has_been_triggered = true
		was_interacted_with.emit()
	if get_overlapping_bodies().size() > 0:
		has_been_triggered = true
		was_interacted_with.emit()
