extends Area3D
class_name InteractionArea

var interactable_type:InteractableObject.InteractableType
signal was_interacted_with
@export var interactable_icon_offset:Vector3 = Vector3(0, 1, 0)

func get_interactive_icon_position() -> Vector3:
	return global_position + interactable_icon_offset

func on_interaction():
	was_interacted_with.emit()
