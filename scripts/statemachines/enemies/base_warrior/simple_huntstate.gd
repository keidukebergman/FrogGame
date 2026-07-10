extends State
class_name MosquitoHuntState

@export var aggro_manager:AggroManager
@export var nav:NavigationAgent3D
@export var body:CharacterBody3D
@export var movement_speed:float = 2
@export var acceleration:float = 1.5
@export var deceleration:float = 5
var movement_direction:Vector3
@export var ground_poller:GroundPoller

@export var attack_range:float = 1

@export var attack_state:State
@export var fall_state:State

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	super._initialize_state(state_machine_node, root_node)
	spawn_position = body.global_position
	nav.avoidance_enabled = true
	nav.radius = 0.2
	nav.max_speed = movement_speed
	nav.velocity_computed.connect(_on_velocity_computed)
	_set_nav_target()

func _enter_state():
	super._enter_state()

var spawn_position:Vector3;

func _set_nav_target() -> void:
	while true:
		if aggro_manager.target != null:
			await get_tree().create_timer(randf_range(0.003, 0.01)).timeout;
			nav.target_position = aggro_manager.target.global_position
		else:
			await get_tree().create_timer(randf_range(0.3, 9)).timeout;
			nav.target_position = Vector3(spawn_position.x + randf_range(-3, 3), 
											spawn_position.y, 
											spawn_position.z + randf_range(-3, 3));

func _state_update(_delta: float) -> void:
	if aggro_manager.target != null:
		var target_distance = aggro_manager.target.global_position.distance_to(self.global_position)
		if  target_distance < attack_range:
			state_machine._change_state(attack_state)
			pass
	else:
		pass

var destination;
var destination_query_timeout:float = 0;

func _exit_state():
	super._exit_state()


var nav_velocity:Vector3 = Vector3.ZERO

func _state_physics_update(delta: float) -> void:
	if ground_poller.is_grounded:
		body.axis_lock_linear_y = true
	else:
		body.axis_lock_linear_y = false
	destination_query_timeout = move_toward(destination_query_timeout, 0, delta)
	if destination_query_timeout == 0:
		destination = nav.get_next_path_position()
		destination_query_timeout = randf_range(0.001, 0.01)
		
	var local_destination = destination - body.global_position
	var direction = local_destination.normalized()
	
	movement_direction = direction
	var direction_dot = body.velocity.dot(direction)
	var acceleration_parameter = acceleration if direction_dot > 0 else deceleration 

	nav.set_velocity(direction * movement_speed)
	
	var yvel = body.velocity.y
	yvel -= 9.82 * get_physics_process_delta_time()
	body.velocity = body.velocity.move_toward(nav_velocity, delta * acceleration_parameter)
	body.velocity.y = yvel
	body.move_and_slide()


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	if is_active:
		nav_velocity = safe_velocity
