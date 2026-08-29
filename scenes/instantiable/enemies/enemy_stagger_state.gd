extends State
class_name EnemyStaggerState

@export var stagger_manager:EnemyStaggerHandler
@export var fallback_state:State
var weak_stagger_time:float = 0.03

var stagger_time:float = 1

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	super._initialize_state(state_machine_node, root_node)
	stagger_manager.was_staggered.connect(on_stagger_received)

func _enter_state():
	super._enter_state()

func on_stagger_received(force):
	if force > 0:
		print("Set stagger time")
		stagger_time = weak_stagger_time

func _exit_state():
	stagger_time = 1
	super._exit_state()

func _state_physics_update(_delta: float):
	root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta * 30)
	root.move_and_slide()

func _state_update(_delta: float):
	if stagger_time > 0:
		stagger_time -= _delta
		if stagger_time <= 0:
			state_machine._change_state(fallback_state)
