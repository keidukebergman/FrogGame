extends State
class_name PlayerDeathState

@export var upward_velocity:float = 2
@export var backward_velocity:float = 2
@export var velocity_smoothing:float = 5
@export var visual_manager:Node3D
@export var hurtbox:Hurtbox

var can_do_ground_acceleration = true;
var movement_direction: Vector3 = Vector3(2,0,2)
signal bounce

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	super._initialize_state(state_machine_node, root_node)

func _enter_state():
	target_velocity = root.velocity
	target_velocity.y = 0
	if target_velocity.length() == 0:
		target_velocity = Vector3(randf_range(0.1, 1), 0, randf_range(0.1, 1));
	target_velocity = target_velocity.normalized() * backward_velocity
	root.velocity = target_velocity
	hurtbox.set_deferred("monitorable", false)
	root.axis_lock_linear_y = false
	super._enter_state()
	can_do_ground_acceleration = true
	_bounce()

func _exit_state():
	super._exit_state()
	pass

var deltarotation = 0
func _state_update(_delta: float):	
	deltarotation += 0.05 * _delta
	visual_manager.rotate_z(deltarotation)
	var psm = state_machine as FrogStateMachine
	if not psm._is_grounded():
		can_do_ground_acceleration = true;
		return
	if can_do_ground_acceleration:
		_bounce()

func _bounce():
	if not can_do_ground_acceleration:
		return
	bounce.emit()
	root.velocity.y = upward_velocity;
	can_do_ground_acceleration = false

var target_velocity:Vector3
func _state_physics_update(_delta: float):
	var psm = state_machine as FrogStateMachine
	var yvel = root.velocity.y
	root.velocity = root.velocity.move_toward(target_velocity, _delta * velocity_smoothing)
	if not psm._is_grounded():
		yvel += state_machine.g_on_fall * 0.8 * _delta
	root.velocity.y = yvel
	root.move_and_slide()
