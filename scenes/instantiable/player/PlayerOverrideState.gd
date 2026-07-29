extends State
class_name PlayerOverrideState

@export var interaction_handler:InteractionHandler

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	super._enter_state()
	interaction_handler.is_active = false

func _exit_state():
	super._exit_state()
	interaction_handler.is_active = true

func _state_update(_delta: float): 
	pass
