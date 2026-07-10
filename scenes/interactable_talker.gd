extends InteractableObject
class_name InteractableTalker

@export var loreObject: String

func _ready() -> void:
	interactable_type = InteractableType.Dialogue
