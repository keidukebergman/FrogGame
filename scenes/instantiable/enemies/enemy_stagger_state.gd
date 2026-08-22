extends State
class_name EnemyStaggerState

@export var stagger_manager:EnemyStaggerHandler
@export var fallback_state:State
var stagger_time:float = 1

func _enter_state():
	print("is staggered!!!")
	super._enter_state()
	stagger_manager.is_active = false
	stagger_manager.was_staggered.connect(on_stagger_received)

func on_stagger_received(force):
	if force > 0:
		stagger_time = 3

func _exit_state():
	stagger_time = 1
	super._exit_state()

func _state_update(_delta: float):
	stagger_time -= _delta
	if stagger_time <= 0:
		state_machine._change_state(fallback_state)
