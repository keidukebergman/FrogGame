extends State
class_name PlayerDashState

@export var airborne_state:PlayerAirborneState
@export var grounded_state:PlayerGroundState
@export var dash_duration: float = 0.2
@export var dash_invulnerability: float = 0.2
@export var dash_velocity_attenuation = 30
var dash_timer:float = 0
var dash_invul_timer: float = 0
@export var dash_velocity = 8

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	is_active = true
	dash_timer = 0
	dash_invul_timer = 0
	var dash_direction:Vector3
	var dash_direction_2D = InputReader._get_attack_direction(root)
	dash_direction.x = -dash_direction_2D.x
	dash_direction.z = -dash_direction_2D.y
	root.velocity = dash_direction*10
	root.move_and_slide()
	super._enter_state()

func _exit_state():
	is_active = false
	super._exit_state()

func _state_update(_delta: float):
	root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta * dash_velocity_attenuation)
	dash_timer += _delta
	root.move_and_slide()
	if dash_timer < dash_duration:
		return
	state_machine._change_state(grounded_state)

func _state_physics_update(_delta: float):
	root.move_and_slide()
	pass
