extends State
class_name PlayerTongueAttackState

@export var jump_state:PlayerJumpState
@export var airborne_state:PlayerAirborneState
@export var ground_state:PlayerGroundState
@export var tongue_attack_manager:TongueAttackManager
@export var body:CharacterBody3D

var attached_node:Node3D = null

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	super._enter_state()
	attached_node = tongue_attack_manager.tongue_attached_node

func _exit_state():
	super._exit_state()
	pass

func _state_update(_delta: float):
	pass

func end_attachment():
	if is_active:
		state_machine._change_state(ground_state)

func _state_physics_update(_delta: float):
	if attached_node != null:
		var direction = tongue_attack_manager.get_direction_to_attached(body)
		var force = direction * tongue_attack_manager.attach_force
		body.velocity = force
		if body.global_position.distance_to(attached_node.global_position) < 0.5:
			tongue_attack_manager._start_retracting()
	else:
		tongue_attack_manager._start_retracting()
	
	body.move_and_slide()
