extends State
class_name PlayerDialogueState

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	super._enter_state()

func _exit_state():
	super._exit_state()

func _state_update(_delta: float):
	pass

func _state_physics_update(_delta: float):
	pass

func _on_dialogue_end():
	pass
