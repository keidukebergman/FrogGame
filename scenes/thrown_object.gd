extends Node3D
class_name ThrownObject

@export var rig:RigidBody3D
@export var hitbox:Hitbox
@export var regular_hurtbox:Hurtbox
@export var projectile_hitbox:Hitbox
@export var projectile_hurtbox:Hurtbox
@export var health_manager:HealthManager
var moving = false
@export var damage_velocity = 1

var hit_objects:Array = []

func _ready() -> void:
	hitbox.hit_entity.connect(on_hitbox_hit_object)
	projectile_hitbox.set_deferred("monitoring", false)
	projectile_hurtbox.set_deferred("monitorable", false)
	regular_hurtbox.set_deferred("monitorable", true)

func calculate_damage() -> float:
	return 50

func on_hitbox_hit_object(node) -> void:
	var hurtbox = node as Hurtbox
	if hurtbox:
		hurtbox.apply_damage(calculate_damage())
	health_manager.set_health(0)

func _process(_delta: float) -> void:
	if rig.linear_velocity.length() < damage_velocity && moving && 1 == 1:
		projectile_hitbox.set_deferred("monitoring", false)
		projectile_hurtbox.set_deferred("monitorable", false)
		regular_hurtbox.set_deferred("monitorable", true)
		moving = false
		hitbox.stop_detecting_hits()
		hit_objects = []

func on_start_moving() -> void:
	hitbox.start_detecting_hits()
	projectile_hitbox.set_deferred("monitoring", true)
	projectile_hurtbox.set_deferred("monitorable", true)
	regular_hurtbox.set_deferred("monitorable", false)
	moving = true

func on_stop_moving() -> void:
	pass
