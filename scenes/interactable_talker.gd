extends InteractableObject
class_name InteractableTalker

@export var loreObject: String
@export var beat:String
@onready var interaction_area = $InteractionArea

func _ready() -> void:
	interactable_type = InteractableType.Dialogue
	interaction_area.interactable_type = interactable_type
	interaction_area.was_interacted_with.connect(on_interaction)

func on_interaction():
	super.on_interaction()
	DialogueManager.instance.initiate_dialogue(loreObject, beat)
