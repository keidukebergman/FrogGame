extends Node3D
class_name EnemyManager

@export var test_enemy:PackedScene
@export var enemies:Array[EnemyEntity]

signal requested_player_information(aggro_manager:AggroManager)

func _ready() -> void:
	for n in 120:
		await get_tree().create_timer(randf_range(0, 0.01)).timeout
		var spawn_vec:Vector3 = Vector3(randf_range(-1,1), 0, randf_range(-1, 1)).normalized() * randf_range(0, 5)
		var enemy = spawn_enemy(test_enemy, spawn_vec) as EnemyEntity
		enemies.append(enemy)
		enemy.aggro_manager.requested_player_target.connect(on_requested_player_information)

func on_requested_player_information(aggro_manager:AggroManager):
	requested_player_information.emit(aggro_manager)
	print("EnemyManager: Request received")

func spawn_enemy(enemy:PackedScene, spawn_position:Vector3) -> Node:
	var enemy_instance = enemy.instantiate()
	NodePaths.dynamic_scene_path.add_child(enemy_instance)
	var enemy_entity:EnemyEntity = enemy_instance as EnemyEntity
	enemy_entity.get_main_object().global_position = spawn_position
	return enemy_instance
