extends DestructibleDecor
class_name DraggableDestructibleDecor

@export var rig:RigidBody3D
@export var dragger:Node3D
@export var force:float

var myparent

func _ready() -> void:
	super._ready()
	myparent = get_parent()
	hurtbox.started_being_dragged.connect(_on_start_dragging)
	hurtbox.stopped_being_dragged.connect(_on_stop_dragging)

func _physics_process(_delta: float) -> void:
	if dragger:
		var direction = dragger.global_position-global_position
		direction.y = 0
		direction = direction.normalized()
		rig.linear_velocity = direction*force


func _on_start_dragging(_dragger, _dragpoint, _force) -> void:
	dragger = _dragger
	force = _force
	rig.axis_lock_linear_x = false
	rig.axis_lock_angular_y = false
	rig.axis_lock_angular_z = false
	rig.axis_lock_linear_x = false
	rig.axis_lock_linear_y = false
	rig.axis_lock_linear_z = false	
	rig.collision_layer = 0

func _on_stop_dragging() -> void:
	force = 0
	dragger = null
