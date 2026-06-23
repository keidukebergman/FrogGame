extends State
class_name RangerAttackState

@export var aggro_manager:AggroManager
@export var windup_time:float = 0.6
@export var attack_time:float = 0.3
@export var next_state:State
var attack_direction:Vector3
@export var can_take_attack_knockback:bool
@export var attack_knockback_force:float
@export var knockback_amount:float
@export var attack_deceleration:float = 10
@export var projectile_speed: float = 8
@export var shots:int = 2
@export var projectile:PackedScene

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	super._initialize_state(state_machine_node, root_node)

func _enter_state():
	is_active = true
	for n in shots:
		if aggro_manager.target == null:
			state_machine._change_state(next_state)
			return
		attack_direction = (aggro_manager.target.global_position - root.global_position).normalized()
		await get_tree().create_timer(windup_time).timeout
		if aggro_manager.target == null:
			state_machine._change_state(next_state)
			return
		fire_arrow()
		await get_tree().create_timer(attack_time).timeout

	state_machine._change_state(next_state)

func _exit_state():
	is_active = false

func _state_update(_delta: float):
	pass

func _state_physics_update(_delta: float):
	root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta * attack_deceleration)
	root.move_and_slide()

func fire_arrow():
	var solution = _firing_solution(aggro_manager.target)
	var projectile_instance = projectile.instantiate()
	NodePaths.dynamic_scene_path.add_child(projectile_instance)
	projectile_instance.global_position = root.global_position
	var proj_obj = projectile_instance as Node3D
	proj_obj.global_rotation.y = solution

func _firing_solution(target: CharacterBody3D):
	var target_global_pos:Vector2 = Vector2(target.global_position.x, target.global_position.z)
	var my_global_pos:Vector2 = Vector2(root.global_position.x, root.global_position.z)
	var delta_pos = target_global_pos-my_global_pos
	var time = _calculate_intercept_time(delta_pos)
	var vel_2d = Vector2(target.velocity.x, target.velocity.y)
	var angle = _calculate_intercept(delta_pos, vel_2d, time)
	return angle

func _calculate_intercept_time(delta_pos:Vector2):
	return delta_pos.length()/projectile_speed

func _calculate_intercept(delta_pos:Vector2, velocity:Vector2, time:float):
	var final_pos = delta_pos + velocity * time
	return -atan2(final_pos.y, final_pos.x) + PI/2 
