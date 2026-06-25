extends State
class_name PlayerGroundAttackState

@export var attack_substates = null
@export var attacks:Array[PlayerAttack] 
var current_attack:PlayerAttack
@export var attack_index = 0
@export var combo_time = 0.8

var combo_timer = 0
var attack_timer = 0
var attack_windup_timer = 0
var wind_up = false

var attack_direction:Vector3

@export var jump_state:PlayerJumpState
@export var airborne_state:PlayerAirborneState
@export var ground_state:PlayerGroundState
@export var effect_manager:EffectManager

@export var can_take_attack_knockback_override = true

func _initialize_state(state_machine_node:FiniteStateMachine, root_node:Node):
	state_machine = state_machine_node
	root = root_node
	current_attack = attacks[0]
	for attack in attacks:
		attack.slash_hitbox.hit_entity.connect(hit_object)
		attack.slash_fx.visible = false;

func _enter_state():
	current_attack = attacks[attack_index]
	var attack_direction_2D = InputReader._get_attack_direction(root)
	attack_direction.x = -attack_direction_2D.x
	attack_direction.z = -attack_direction_2D.y
	set_hitbox_rotation()
	set_slash_rotation()
	attack_timer = 0
	wind_up = false
	attack_windup_timer = 0
	current_attack.can_take_attack_knockback = true
	super._enter_state()

func _start_attack():
	root.add_force(attack_direction * current_attack.slice_movement_force)
	start_registering_hits()
	current_attack.slash_fx.visible = true;

func _process(_delta: float) -> void:
	if combo_timer > 0 && attack_index != 0 && is_active == false:
		combo_timer -= _delta
		if combo_timer <= 0:
			attack_index = 0

func _exit_state():
	stop_registering_hits()
	current_attack.slash_fx.visible = false;
	super._exit_state()
	attack_index += 1
	if attack_index == attacks.size():
		attack_index = 0
	combo_timer = combo_time

func _state_update(_delta: float):
	root.move_and_slide()
	attack_windup_timer += _delta
	if current_attack.can_take_attack_knockback:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta * current_attack.attack_deceleration)
	else:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta * current_attack.bounce_deceleration)
	if attack_windup_timer < current_attack.attack_windup_time:
		return
	if not wind_up:
		wind_up = true
		_start_attack()
	attack_timer += _delta
	if attack_timer >= current_attack.attack_time:
		attack_timer = 0
		if state_machine._is_grounded():
			state_machine._change_state(ground_state)
		else:
			state_machine._change_state(airborne_state)

func hit_object(object):
	var hurtbox = object
	if hurtbox is Hurtbox and hurtbox.verify_hit():
		apply_damage(hurtbox)
		if current_attack.can_take_attack_knockback:
			root.set_only_force(current_attack.attack_knockback_force * -attack_direction)

func apply_damage(hurtbox:Hurtbox):
	hurtbox.apply_damage(current_attack.damage);
	var knockback_direction = Vector3(attack_direction.x, 0, attack_direction.z)
	hurtbox.apply_effects({"knockback" : current_attack.knockback_amount * knockback_direction});

func set_hitbox_rotation():
	var dir:Vector2 = Vector2(attack_direction.z, attack_direction.x)
	var angle = -atan2(dir.x, dir.y)
	current_attack.slash_hitbox.rotation = Vector3(current_attack.slash_hitbox.rotation.x, angle, current_attack.slash_hitbox.rotation.z)

func set_slash_rotation():
	var dir:Vector2 = Vector2(attack_direction.z, attack_direction.x)
	var angle = -atan2(dir.x, dir.y)
	current_attack.slash_fx.rotation = Vector3(current_attack.slash_fx.rotation.x, angle, current_attack.slash_fx.rotation.z)

func start_registering_hits ():
	current_attack.slash_hitbox.start_detecting_hits();

func stop_registering_hits ():
	current_attack.slash_hitbox.stop_detecting_hits();
