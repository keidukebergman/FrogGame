extends State
class_name PlayerAirborneState

@export var grounded_state:PlayerGroundState
@export var movement_speed:float = 4
@export var acceleration:float = 2
@export var duration_before_fall:float = 0.5
var fall_timer = 0
@export var air_drag = 5

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node

func _enter_state():
	fall_timer = 0
	root.velocity.y = 0
	super._enter_state()

func _exit_state():
	super._exit_state()
	pass

func _state_update(_delta: float):	
	fall_timer += _delta
	var input_vector = Vector3(-InputReader.movement_vector.x, 0, InputReader.movement_vector.y).normalized()
	var horizontal_velocity = root.velocity
	
	horizontal_velocity.y = 0
	horizontal_velocity = lerp(horizontal_velocity, input_vector * movement_speed, _delta * acceleration)
	
	if fall_timer < duration_before_fall:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta*air_drag)
		return
	var new_velocity = horizontal_velocity
	new_velocity.y = root.velocity.y;
	if root.velocity.y > 0:
		new_velocity.y += state_machine.g_on_rise * _delta
	if root.velocity.y <= 0:
		new_velocity.y += state_machine.g_on_fall * _delta
		if(state_machine._is_grounded()):
			state_machine._change_state(grounded_state)
	#TODO: set variables here
	new_velocity.y = clamp(new_velocity.y, -20, 1000)  
	root.velocity = new_velocity
	

func _state_physics_update(_delta: float):
	root.move_and_slide()
	pass
