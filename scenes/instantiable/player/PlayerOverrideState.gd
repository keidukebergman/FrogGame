extends State
class_name PlayerOverrideState

@export var interaction_handler:InteractionHandler
@export var tongue_handler:TongueAttackManager
@export var hurtbox:Hurtbox

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	super._enter_state()
	interaction_handler.is_active = false
	tongue_handler.active = false
	hurtbox.is_active = false
	

func _exit_state():
	super._exit_state()
	interaction_handler.is_active = true
	tongue_handler.active = true
	hurtbox.is_active = true
