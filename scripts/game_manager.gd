extends Node3D

@export var game_state_machine = null

@export var player_manager:PlayerManager
@export var enemy_manager:EnemyManager
@export var player_fx_relay:PlayerFXRelay
@export var main_camera:MainCamera
@export var dialogue_manager:DialogueManager
@export var ui_manager:UI_Manager
@export var scene_manager:SceneManager
@export var data_manager:DataManager


func _ready() -> void:
	data_manager.load_data()
	enemy_manager.requested_player_information.connect(on_player_information_requested)
	dialogue_manager.began_dialogue.connect(player_manager.on_dialogue_start)
	dialogue_manager.finished_dialogue.connect(player_manager.on_dialogue_end)
	scene_manager.requested_level_switch.connect(on_level_switch_request)
	play_game()

func on_level_switch_request(level, gate):
	var leveltype = await scene_manager.async_switch_level(level)
	if leveltype == Level.LevelType.None:
		push_error("ERROR: No level loaded")
		return
	var lvl:Level = scene_manager.current_level
	var spawn_position = lvl.get_gate_spawn_position(gate)
	spawn_position.y = 0.778
	player_manager.get_player().main_object.global_position = spawn_position
	main_camera.min_coords = scene_manager.current_level.camera_minimum_position
	main_camera.max_coords = scene_manager.current_level.camera_maximum_position

func play_game():
	var scenepath = "res://scenes/stages/" + data_manager.get_save_parameter("location") +".tscn"
	on_level_switch_request(scenepath, 0)
	if player_manager.get_player() == null:
		_initialize_player(Vector3(0, 0.778, 0))

func _start_cinematic_level():
	if player_manager.get_player() != null:
		pass

func _end_cinematic_level():
	if player_manager.get_player() != null:
		pass

func _initialize_player(player_spawn_position:Vector3) -> void:
	player_manager.spawn_player(player_spawn_position)
	player_manager.get_player().bounced.connect(on_player_bounced)
	var phm = player_manager.player.health_manager
	phm.applied_damage.connect(_on_player_taken_damage)
	phm.applied_healing.connect(_on_player_healed)
	phm.depleted_health.connect(_on_player_death)
	main_camera.target = player_manager.get_player().get_main_object()
	ui_manager.stamina_manager = player_manager.get_player().stamina_manager
	ui_manager.health_bar_manager._reset(100)

func on_player_information_requested(aggro_manager:AggroManager):
	var player_node = player_manager.get_player_information()
	aggro_manager.receive_player_target(player_node)

func _on_player_taken_damage(_damage, current_health):
	var damaged:bool = true
	ui_manager._on_player_health_change(damaged, current_health)
	player_fx_relay.on_player_took_damage(_damage)

func _on_player_death():
	main_camera.on_player_death()
	pass

func on_player_bounced():
	player_fx_relay.on_player_death_bounce()

func _on_player_healed(_healing, current_health):
	var damaged:bool = false
	ui_manager._on_player_health_change(damaged, current_health)

func _on_request_level_switch():
	pass
