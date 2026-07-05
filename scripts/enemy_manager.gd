extends Node3D
class_name EnemyManager

@export var test_enemy:PackedScene
@export var enemy_roster:Array[PackedScene]
var enemies:Array[EnemyEntity]

signal requested_player_information(aggro_manager:AggroManager)

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	for n in 3:
		await get_tree().create_timer(randf_range(0, 0.01)).timeout
		var spawn_vec:Vector3 = Vector3(randf_range(-3, 3), 0, randf_range(-3, 3))
		var enemy = spawn_enemy(enemy_roster[randi_range(0, enemy_roster.size() - 1)], spawn_vec) as EnemyEntity
		enemies.append(enemy)
		enemy.aggro_manager.requested_player_target.connect(on_requested_player_information)

func on_requested_player_information(aggro_manager:AggroManager):
	requested_player_information.emit(aggro_manager)
	print("EnemyManager: Request received")

func spawn_enemy(enemy:PackedScene, spawn_position:Vector3) -> Node:
	var enemy_instance = enemy.instantiate()
	NodePaths.dynamic_scene_path.add_child(enemy_instance)
	var enemy_entity:EnemyEntity = enemy_instance as EnemyEntity
	enemy_entity.global_position = spawn_position
	return enemy_instance
