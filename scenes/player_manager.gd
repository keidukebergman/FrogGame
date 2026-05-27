extends Node3D
class_name PlayerManager

@export var player_prefab:PackedScene
@export var player:PlayerEntity

signal player_took_damage(damage:float)

func get_player () -> PlayerEntity:
	if player:
		return player
	else:
		return null

func on_player_death ():
	player = null

func spawn_player(spawn_position:Vector3) -> Node:
	var player_instance = player_prefab.instantiate()
	NodePaths.dynamic_scene_path.add_child(player_instance)
	var player_entity:PlayerEntity = player_instance as PlayerEntity
	player_entity.get_main_object().global_position = spawn_position
	player_entity.health_manager.applied_damage.connect(on_player_take_damage)
	return player_entity

func get_player_information() -> Node3D:
	if player:
		return player.get_main_object()
	else:
		return null

func on_player_take_damage(damage:float) -> void:
	player_took_damage.emit(damage)
