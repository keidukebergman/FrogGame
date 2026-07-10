extends Node3D
class_name InteractableObject

var interactable_type:InteractableType

enum InteractableType{
	None,
	Pickup,
	Dialogue,
	Interface
}

func on_interaction():
	pass
