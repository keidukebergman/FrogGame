extends State
class_name PlayerAirborneState

@export var grounded_state:PlayerGroundState
@export var dash_state:PlayerDashState
@export var tongue_attack_handler:TongueAttackManager
@export var movement_speed:float = 4
@export var acceleration:float = 2
@export var duration_before_fall:float = 0.5
var fall_timer = 0
@export var air_drag = 5

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	print("entered airborne")
	fall_timer = 0
	root.axis_lock_angular_z =true
	super._enter_state()

func _exit_state():
	super._exit_state()
	pass

func _state_update(_delta: float):
	var input_vector = Vector3(-InputReader.movement_vector.x, 0, InputReader.movement_vector.y).normalized()
	var horizontal_velocity = root.velocity
	horizontal_velocity.y = 0
	horizontal_velocity = lerp(horizontal_velocity, input_vector * movement_speed, _delta * acceleration)
	if(state_machine._is_grounded()):
			print("Go back to ground!!")
			tongue_attack_handler.active = true
			state_machine._change_state(grounded_state)
			return
	if fall_timer < duration_before_fall:
		_handle_coyote(_delta)
	else:
		_handle_fall(_delta)
	
func _handle_fall(_delta: float):
	tongue_attack_handler.active = false
	root.axis_lock_linear_y = false
	var new_velocity = root.velocity
	new_velocity.y = root.velocity.y
	if root.velocity.y <= 0:
		new_velocity.y += state_machine.g_on_fall * _delta
	#TODO: set variables here
	new_velocity.y = clamp(new_velocity.y, -20, 1000)  
	root.velocity = new_velocity
	
func _handle_coyote(_delta: float):
	if Input.is_action_just_pressed("dash"):
		state_machine._change_state(dash_state)
	if tongue_attack_handler.tongue_state != TongueAttackManager.TongueState.EXTENDING:
		fall_timer += _delta
	if fall_timer < duration_before_fall:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta*air_drag)
		return

func _state_physics_update(_delta: float):
	root.move_and_slide()
	pass
