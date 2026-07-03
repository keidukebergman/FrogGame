extends State
class_name PlayerChargeState

@export var airborne_state:PlayerAirborneState
@export var grounded_state:PlayerGroundState
@export var attack_state:PlayerGroundAttackState
@export var chargeup_time:float = 0.3
@export var dash_state:PlayerDashState

var charge_up_timer = 0


func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	super._enter_state()
	charge_up_timer = 0

func _exit_state():
	super._exit_state()

func _state_update(_delta: float):
	charge_up_timer += _delta
	if(Input.is_action_just_released("attack")):
		if charge_up_timer >= chargeup_time:
			state_machine._change_state(attack_state)
		else:
			state_machine._change_state(grounded_state)

func _state_physics_update(_delta: float):
	pass
