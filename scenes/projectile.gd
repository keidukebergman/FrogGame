extends RigidBody3D
class_name Projectile

@export var projectile_speed = 6
@export var projectile_damage = 20
@export var hitbox:Hitbox
@export var draggable_hurtbox: DraggableHurtbox
@export var deflection_manager: ProjectileDeflectionManager
@export var is_draggable = true;
@export var is_parriable = true;
var origin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_parriable:
		draggable_hurtbox.monitorable = false
	hitbox.start_detecting_hits()
	if hitbox:
		hitbox.hit_entity.connect(_on_hit_target)
	if deflection_manager:
		draggable_hurtbox.received_attack.connect(deflection_manager.on_take_attack)
	draggable_hurtbox.received_attack.connect(_on_deflection)

func initialize_shot(origin:Node3D):
	self.origin = origin
	var basis = get_global_transform().basis
	var forward = basis.z
	linear_velocity = forward * projectile_speed

func _on_deflection(_data):
	print("Deflected")
	projectile_damage *= 10

func _on_hit_target(hit_object:Node3D):
	var hurtbox = hit_object as Hurtbox
	if hurtbox == null:
		return;
	var attack_data = AttackData.new()
	attack_data.attacker = origin
	attack_data.damage = projectile_damage
	attack_data.receiving_hurtbox = hurtbox
	attack_data.attacking_hitbox = hitbox
	hurtbox.apply_attack(attack_data)
	queue_free() #TODO: Switch out for something actually useful
