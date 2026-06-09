extends DestructibleDecor
class_name DraggableDestructibleDecor

@export var rig:RigidBody3D
@export var thrown_object:ThrownObject
@export var dragged_hurtbox:DraggableHurtbox
@export var affected_by_gravity:bool
@export var ground_poller:GroundPoller
var dragger:Node3D
var force:float
var damage_velocity = 1.0
var myparent

func _ready() -> void:
	super._ready()
	myparent = get_parent()
	hurtbox.started_being_dragged.connect(_on_start_dragging)
	hurtbox.stopped_being_dragged.connect(_on_stop_dragging)
	dragged_hurtbox.started_being_dragged.connect(_on_start_dragging)
	dragged_hurtbox.stopped_being_dragged.connect(_on_stop_dragging)

func _physics_process(_delta: float) -> void:
	if dragger:
		var direction = dragger.global_position-global_position
		direction.y = 0
		direction = direction.normalized()
		rig.linear_velocity = direction*force/rig.mass
	if rig.linear_velocity.length() < damage_velocity:
		pass
	if(global_position + rig.linear_velocity != global_position):
		look_at(global_position + rig.linear_velocity)
	if affected_by_gravity && !ground_poller.is_grounded:
		rig.axis_lock_linear_y = false

func _on_start_dragging(_dragger, _dragpoint, _force) -> void:
	dragger = _dragger
	force = _force
	rig.axis_lock_linear_x = true
	rig.axis_lock_angular_z = true
	rig.axis_lock_linear_x = false
	rig.axis_lock_linear_z = false
	rig.collision_layer = 0
	thrown_object.on_start_moving()

func _on_stop_dragging() -> void:
	force = 0
	dragger = null
	#thrown_object.on_stop_moving()
