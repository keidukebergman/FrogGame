extends State
class_name MosquitoHuntState


@export var aggro_manager:AggroManager
@export var nav:NavigationAgent3D
@export var body:CharacterBody3D
@export var movement_speed:float = 2
@export var acceleration:float = 1.5
@export var deceleration:float = 5
var movement_direction:Vector3

@export var attack_range:float = 1

@export var attack_state:State


func _enter_state() -> void:
	_set_nav_target()

func _set_nav_target() -> void:
	while true:
		if aggro_manager.target != null:
			await get_tree().create_timer(randf_range(0.3, 1)).timeout;
			nav.target_position = aggro_manager.target.global_position
		else:
			await get_tree().create_timer(randf_range(0.3, 9)).timeout;
			nav.target_position = Vector3(body.global_position.x + randf_range(-15, 15), 
											body.global_position.y, 
											body.global_position.z + randf_range(-15, 15));

func _state_update(_delta: float) -> void:
	if aggro_manager.target != null:
		var target_distance = aggro_manager.target.global_position.distance_to(self.global_position)
		if  target_distance < attack_range:
			state_machine._change_state(attack_state)
			pass
	else:
		pass


func _state_physics_updates(delta: float) -> void:
	var destination = nav.get_next_path_position()
	var local_destination = destination - body.global_position
	var direction = local_destination.normalized()
	
	movement_direction = direction
	var direction_dot = body.velocity.dot(direction)
	var acceleration_parameter = acceleration if direction_dot > 0 else deceleration 
	
	var yvel = body.velocity.y
	yvel -= 9.82 * delta
	body.velocity = body.velocity.move_toward(movement_direction * movement_speed,\
		delta * acceleration_parameter)
	body.velocity.y = yvel
	
	nav.velocity = Vector3(body.velocity.x, 0, body.velocity.z)
	body.move_and_slide()
