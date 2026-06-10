extends GameEntity
class_name EnemyEntity

@export var aggro_manager:AggroManager

func _ready() -> void:
	var sel = self.get_main_object() as Node3D
	print("Spawned at ", sel.global_position, " : ", get_child(0).global_position)
