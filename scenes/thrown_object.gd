extends Node3D
class_name ThrownObject

@export var rig:RigidBody3D
@export var hitbox:Hitbox
@export var regular_hurtbox:Hurtbox
@export var projectile_hitbox:Hitbox
@export var projectile_hurtbox:Hurtbox
var moving = false
@export var damage_velocity = 0

var hit_objects:Array = []

func _ready() -> void:
	hitbox.hit_entity.connect(on_hitbox_hit_object)
	projectile_hitbox.monitoring = false
	projectile_hurtbox.monitorable = false
	regular_hurtbox.monitorable = true

func calculate_damage() -> float:
	return 10

func on_hitbox_hit_object(node) -> void:
	var hurtbox = node as Hurtbox
	if hurtbox:
		hurtbox.apply_damage(calculate_damage())

func _process(_delta: float) -> void:
	if rig.linear_velocity.length() < damage_velocity && moving && 1 == 4:
		projectile_hitbox.monitoring = false
		projectile_hurtbox.monitorable = false
		regular_hurtbox.monitorable = true
		moving = false

func on_start_moving() -> void:
	hitbox.start_detecting_hits()
	projectile_hitbox.monitoring = true
	projectile_hurtbox.monitorable = true
	regular_hurtbox.monitorable = false
	moving = true

func on_stop_moving() -> void:
	hitbox.stop_detecting_hits()
	hit_objects = []
