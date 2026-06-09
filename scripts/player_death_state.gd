extends State
class_name PlayerDeathState

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	super._initialize_state(state_machine_node, root_node)

func _enter_state():
	super._enter_state()

func _exit_state():
	super._exit_state()
	pass

func _state_update(_delta: float):	
	pass
	
	

func _state_physics_update(_delta: float):
	pass
