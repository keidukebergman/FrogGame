extends Area3D
class_name InteractionArea

var interactable_type:InteractableObject.InteractableType
signal was_interacted_with

func on_interaction():
	was_interacted_with.emit()
