extends GameEntity
class_name PlayerEntity

@export_group("System scripts")
@export var health_manager:HealthManager
@export var death_manager:DeathManager
@export var state_machine:FrogStateMachine

@export_subgroup("States")
@export var state_grounded:PlayerGroundState
@export var state_attack:PlayerGroundAttackState
@export var state_tongue_attack:PlayerTongueAttackState
@export var state_airborne:PlayerAirborneState
@export var state_jump:PlayerJumpState
@export var state_death:PlayerDeathState
@export_subgroup("")

@export var effect_manager:EffectManager
@export var water_splash_manager:WaterSplashHandler

@export_group("Subsystems")
@export var hurtbox:Hurtbox
@export var hitbox:Hitbox

var display_health:float
var display_max_health:float

signal depleted_health 
signal bounced

func _enter_tree():
	hurtbox.took_damage.connect(health_manager.apply_damage)
	health_manager.depleted_health.connect(death_manager.die)
	health_manager.depleted_health.connect(_on_health_depleted)
	water_splash_manager.entered_water.connect(state_death.on_water_death)
	state_death.bounce.connect(_on_bounce)

func _on_bounce():
	bounced.emit()

func _on_health_depleted():
	depleted_health.emit()
	state_machine._change_state(state_death)

func _process(_delta: float) -> void:
	display_health = health_manager.health;
	display_max_health = health_manager.max_health;
