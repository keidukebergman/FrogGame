extends Node3D
class_name Draggable

@export var body:CharacterBody3D
@export var hurtbox:DraggableHurtbox
var dragger:Node3D = null
@export var dragforce = 5

func _ready() -> void:
	hurtbox.started_being_dragged.connect(_start_drag)
	hurtbox.stopped_being_dragged.connect(_end_drag)

func _start_drag(node) -> void:
	dragger = node

func _physics_process(_delta: float) -> void:
	if dragger != null:
		body.velocity = (dragger.global_position - body.global_position).normalized() * dragforce

func _end_drag() -> void:
	dragger = null
