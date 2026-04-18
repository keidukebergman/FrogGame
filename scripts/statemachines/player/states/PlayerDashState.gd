extends State
class_name PlayerDashState

@export var airborne_state:PlayerAirborneState
@export var grounded_state:PlayerGroundState
@export var dash_duration: float = 0.8
@export var dash_invulnerability: float = 0.4
var dash_timer:float = 0
var dash_invul_timer: float = 0

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	is_active = true
	root.move_and_slide()
	dash_timer = 0
	dash_invul_timer = 0
	super._enter_state()

func _exit_state():
	is_active = false
	super._exit_state()

func _state_update(_delta: float):
	state_machine._change_state(grounded_state)

func _state_physics_update(_delta: float):
	root.move_and_slide()
	pass
