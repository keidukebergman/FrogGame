extends State
class_name MosquitoAttackState

@export var aggro_manager:AggroManager
@export var hitbox:Hitbox
@export var attack_visual:Node3D
@export var windup_time:float = 0.6
@export var attack_time:float = 0.3
@export var next_state:State
@export var attack_deceleration:float = 10
@export var bounce_deceleration:float = 5
@export var attack_velocity:float = 10
var registering = false
var attack_direction:Vector3
@export var can_take_attack_knockback:bool
@export var attack_knockback_force:float
@export var knockback_amount:float

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	super._initialize_state(state_machine_node, root_node)
	hitbox.hit_entity.connect(hit_object)
	attack_visual.visible = false

func _enter_state():
	is_active = true
	if aggro_manager.target == null:
		state_machine._change_state(next_state)
	attack_direction = (aggro_manager.target.global_position - root.global_position).normalized()
	await get_tree().create_timer(windup_time).timeout
	registering = true
	set_hitbox_rotation()
	set_slash_indicator_rotation()
	hitbox.start_detecting_hits()
	attack_visual.visible = true
	root.add_force(attack_direction*attack_velocity)
	await get_tree().create_timer(attack_time).timeout
	hitbox.stop_detecting_hits()
	attack_visual.visible = false
	state_machine._change_state(next_state)

func _exit_state():
	registering = false
	is_active = false

func hit_object(object):
	var hurtbox = object
	if hurtbox is Hurtbox and hurtbox.verify_hit():
		apply_damage(hurtbox)
		if can_take_attack_knockback:
			root.set_only_force(attack_knockback_force * -attack_direction)

func apply_damage(hurtbox:Hurtbox):
	hurtbox.apply_damage(10);
	var knockback_direction = Vector3(attack_direction.x, 0, attack_direction.z)
	hurtbox.apply_effects({"knockback" : knockback_amount * knockback_direction});

func _state_update(_delta: float):
	if registering:
		pass
	else:
		pass

func _state_physics_update(_delta: float):
	root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta*attack_deceleration)
	root.move_and_slide()
	
func set_hitbox_rotation():
	var dir:Vector2 = Vector2(attack_direction.z, attack_direction.x)
	var angle = -atan2(dir.x, dir.y)
	hitbox.rotation = Vector3(hitbox.rotation.x, angle, hitbox.rotation.z)

func set_slash_indicator_rotation():
	var dir:Vector2 = Vector2(attack_direction.z, attack_direction.x)
	var angle = -atan2(dir.x, dir.y)
	attack_visual.rotation = Vector3(attack_visual.rotation.x, angle, attack_visual.rotation.z)
