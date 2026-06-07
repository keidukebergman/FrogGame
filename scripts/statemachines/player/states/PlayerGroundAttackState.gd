extends State
class_name PlayerGroundAttackState

@export var attack_substates = null
@export var slice_movement_force:float = 4
@export var attack_time:float = 0.5
@export var attack_windup_time:float = 0.2
@export var knockback_amount:float = 5.0
var attack_timer = 0
var attack_windup_timer = 0
var wind_up = false
@export var slice_movement_curve:Curve
var attack_direction:Vector3
@export var slash_hitbox:Node3D
@export var slash_fx:Node3D

@export var jump_state:PlayerJumpState
@export var airborne_state:PlayerAirborneState
@export var ground_state:PlayerGroundState
@export var effect_manager:EffectManager
@export var attack_deceleration:float = 10
@export var bounce_deceleration:float = 5

var can_take_attack_knockback = true
@export var attack_knockback_force = 5

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node
	slash_hitbox.hit_entity.connect(hit_object)
	slash_fx.visible = false;

func _enter_state():
	var attack_direction_2D = InputReader._get_attack_direction(root)
	attack_direction.x = -attack_direction_2D.x
	attack_direction.z = -attack_direction_2D.y
	attack_timer = 0
	wind_up = false
	attack_windup_timer = 0
	can_take_attack_knockback = true
	super._enter_state()
	
func _start_attack():
	root.add_force(attack_direction*slice_movement_force)
	start_registering_hits()
	slash_fx.visible = true;

func _exit_state():
	stop_registering_hits()
	slash_fx.visible = false;
	super._exit_state()

func _state_update(_delta: float):
	root.move_and_slide()
	attack_windup_timer += _delta
	if can_take_attack_knockback:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta*attack_deceleration)
	else:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta*bounce_deceleration)
	if attack_windup_timer < attack_windup_time:
		return
	if not wind_up:
		wind_up = true
		_start_attack()
	attack_timer += _delta
	if attack_timer >= attack_time:
		attack_timer = 0
		if state_machine._is_grounded():
			state_machine._change_state(ground_state)
		else:
			state_machine._change_state(airborne_state)

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

func set_hitbox_rotation():
	var dir:Vector2 = Vector2(attack_direction.z, attack_direction.x)
	var angle = -atan2(dir.x, dir.y)
	slash_hitbox.rotation = Vector3(slash_hitbox.rotation.x, angle, slash_hitbox.rotation.z)

func set_slash_rotation():
	var dir:Vector2 = Vector2(attack_direction.z, attack_direction.x)
	var angle = -atan2(dir.x, dir.y)
	slash_fx.rotation = Vector3(slash_fx.rotation.x, angle, slash_fx.rotation.z)

func start_registering_hits ():
	set_hitbox_rotation()
	set_slash_rotation()
	slash_hitbox.start_detecting_hits();

func stop_registering_hits ():
	slash_hitbox.stop_detecting_hits();

func _state_physics_update(_delta: float):
	pass
