extends Node3D
class_name DestructibleDecor

@export var health_manager : HealthManager
@export var death_manager : DeathManager
@export var hurtbox : Hurtbox
@export var drop_manager = null #TODO: add later

func _ready() -> void:
	hurtbox.took_damage.connect(health_manager.apply_damage)
	health_manager.depleted_health.connect(death_manager.die)
