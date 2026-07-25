extends Node3D
class_name InteractionHandler

@onready var interaction_area = $InteractionArea
@export var interaction_icon: Node3D

signal found_interactable 
signal lost_interactables

var current_target_interaction_area: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var interactables:Array[InteractionArea] = get_interactables()
	if interaction_icon: interaction_icon.visible = interactables.size() > 0;
	if interactables.size() > 0:
		if current_target_interaction_area != interactables[0]:
			current_target_interaction_area = interactables[0]
			print(current_target_interaction_area)
			found_interactable.emit()
		if Input.is_action_just_pressed("interact"):
			interactables[0].on_interaction()
			print("Interacted with ", interactables[0])
	elif current_target_interaction_area != null:
		lost_interactables.emit()
		current_target_interaction_area = null

func get_interactables() -> Array[InteractionArea]:
	var result: Array[InteractionArea] = []
	for area in interaction_area.get_overlapping_areas():
		var area_as_interactable = area as InteractionArea
		if area_as_interactable:
			result.append(area)
	result.sort_custom(comparator)
	return result

func comparator (a, b):
	if a.interactable_type != b.interactable_type:
		return a.interactable_type < b.interactable_type
	return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position)
