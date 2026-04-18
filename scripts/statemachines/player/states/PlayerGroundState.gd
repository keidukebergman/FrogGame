extends State
class_name PlayerGroundState

@export var movement_speed:float = 5
var movement_vector:Vector3
@export var acceleration:float = 10
@export var deceleration:float = 10
@export var idle_velocity_dampening:float = 8
var dash_timer = 0;
@export var dash_state:PlayerDashState
@export var airborne_state:PlayerAirborneState
@export var ground_attack_state:PlayerGroundAttackState
@export var sprite:Sprite3D

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	dash_timer = 0
	is_active = true
	super._enter_state()
	pass

func _exit_state():
	is_active = false
	super._exit_state()
	pass

func _state_update(_delta: float): 
	if Input.is_action_just_pressed("attack"):
		state_machine._change_state(ground_attack_state)
	if Input.is_action_just_pressed("dash"):
		state_machine._change_state(dash_state)
	if not state_machine._is_grounded():
		state_machine._change_state(airborne_state)
	var mouse_vector = InputReader._get_mouse_object_offset(root).normalized()
	var renderer = state_machine.renderer
	if mouse_vector.x < 0:
		renderer.flip_h = false
	else:
		renderer.flip_h = true


func calculate_new_velocity(target_velocity:Vector3, current_velocity:Vector3, delta:float) -> Vector3:
	var new_velocity:Vector3 = current_velocity
	var dot:float = target_velocity.dot(current_velocity)
	if Vector2(target_velocity.x, target_velocity.y) == Vector2.ZERO:
		new_velocity = new_velocity.move_toward(target_velocity, delta*idle_velocity_dampening)
	elif dot >= 0:
		new_velocity = new_velocity.move_toward(target_velocity, delta*acceleration)
	else:
		new_velocity = new_velocity.move_toward(target_velocity, delta*deceleration)
	return new_velocity

func _state_physics_update(_delta: float):
	var input_vector = Vector3(-InputReader.movement_vector.x, 0, InputReader.movement_vector.y).normalized()
	var target_velocity = root.velocity
	target_velocity.y = 0
	target_velocity = input_vector * movement_speed
	target_velocity.z /= sin(deg_to_rad(60))
	var new_velocity = calculate_new_velocity(target_velocity, root.velocity, _delta)
	root.velocity = new_velocity
	root.velocity.y = 0
	root.move_and_slide()
