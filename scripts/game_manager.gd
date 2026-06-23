extends Node3D

@export var player_manager:PlayerManager
@export var enemy_manager:EnemyManager
@export var player_fx_relay:PlayerFXRelay
@export var main_camera:MainCamera

@export var ui_manager:UI_Manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var phm = player_manager.player.health_manager
	phm.applied_damage.connect(_on_player_taken_damage)
	phm.applied_healing.connect(_on_player_healed)
	phm.depleted_health.connect(_on_player_death)
	enemy_manager.requested_player_information.connect(on_player_information_requested)
	player_manager.get_player().bounced.connect(on_player_bounced)

func on_player_information_requested(aggro_manager:AggroManager):
	var player_node = player_manager.get_player_information()
	aggro_manager.receive_player_target(player_node)

func _on_player_taken_damage(_damage, current_health):
	var damaged:bool = true
	ui_manager._on_player_health_change(damaged, current_health)
	player_fx_relay.on_player_took_damage(_damage)

func _on_player_death():
#	main_camera.on_player_death()
	pass

func on_player_bounced():
	player_fx_relay.on_player_death_bounce()

func _on_player_healed(_healing, current_health):
	var damaged:bool = false
	ui_manager._on_player_health_change(damaged, current_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
