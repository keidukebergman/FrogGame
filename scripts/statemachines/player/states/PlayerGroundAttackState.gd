extends State
class_name PlayerGroundAttackState

@export var attack_substates = null
@export var attacks:Array[PlayerAttack] 
var current_attack:PlayerAttack
@export var attack_index = 0
@export var combo_time = 0.8
@export var attack_cancel_time = 0.9

var combo_timer = 0
var attack_timer = 0
var attack_windup_timer = 0
var attack_winddown_timer = 0
var attack_cancel_timer = 0
var wind_up = false

var attack_direction:Vector3

@export var jump_state:PlayerJumpState
@export var dash_state:PlayerDashState
@export var airborne_state:PlayerAirborneState
@export var ground_state:PlayerGroundState
@export var effect_manager:EffectManager

@export var can_take_attack_knockback_override = true
var attack_state:AttackState

enum AttackState {
	Windup,
	Attack,
	Winddown
}

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
	current_attack.can_take_attack_knockback = true
	attack_state = AttackState.Windup
	super._enter_state()
	(state_machine.renderer as AnimatedSprite3D).animation = "attack_draw"
	(state_machine.renderer as AnimatedSprite3D).play()
	print((state_machine.renderer as AnimatedSprite3D).animation)
	print("playing attack anim")

func _start_attack():
	root.add_force(attack_direction * current_attack.slice_movement_force)
	start_registering_hits()
	current_attack.slash_fx.visible = true;
	(state_machine.renderer as AnimatedSprite3D).animation = "attack"
	(state_machine.renderer as AnimatedSprite3D).play()

func _stop_attack():
	stop_registering_hits()
	current_attack.slash_fx.visible = false;

func _process(_delta: float) -> void:
	if combo_timer > 0 && attack_index != 0 && is_active == false:
		combo_timer -= _delta
		if combo_timer <= 0:
			attack_index = 0

func _exit_state():
	_stop_attack()
	super._exit_state()
	attack_index += 1
	if attack_index == attacks.size():
		attack_index = 0
	combo_timer = combo_time

func _state_update(_delta: float):
	root.move_and_slide()
	attack_timer += _delta
	print((state_machine.renderer as AnimatedSprite3D).animation)
	if current_attack.can_take_attack_knockback:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta * current_attack.attack_deceleration)
	else:
		root.velocity = root.velocity.move_toward(Vector3.ZERO, _delta * current_attack.bounce_deceleration)
	match attack_state:
		AttackState.Windup:
			if attack_timer > current_attack.attack_windup_time:
				attack_state = AttackState.Attack
				_start_attack()
		AttackState.Attack:
			if attack_timer > current_attack.attack_time + current_attack.attack_windup_time:
				attack_state = AttackState.Winddown
				_stop_attack()
		AttackState.Winddown:
			if attack_timer > current_attack.attack_winddown_time + current_attack.attack_time + current_attack.attack_windup_time:
				if state_machine._is_grounded():
					state_machine._change_state(ground_state)
				else:
					state_machine._change_state(airborne_state)

	if attack_timer >= current_attack.cancel_time * (current_attack.attack_winddown_time + current_attack.attack_time + current_attack.attack_windup_time):
		if InputReader.dash_input.is_active():
			state_machine._change_state(dash_state)
		if InputReader.attack_input.is_active():
			state_machine._change_state(ground_state)


func hit_object(object):
	var hurtbox = object
	if hurtbox is Hurtbox and hurtbox.verify_hit():
		apply_damage(hurtbox)
		if current_attack.can_take_attack_knockback:
			root.set_only_force(current_attack.attack_knockback_force * -attack_direction)

func apply_damage(hurtbox:Hurtbox):
	var data = AttackData.new()
	data.attacker = root
	data.attacking_hitbox = current_attack.slash_hitbox
	data.damage = current_attack.damage
	var knockback_direction = Vector3(attack_direction.x, 0, attack_direction.z)
	data.effects = {"knockback" : current_attack.knockback_amount * knockback_direction, "stagger" : 2}
	hurtbox.apply_attack(data)

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
