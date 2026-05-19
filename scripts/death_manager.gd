extends Node3D
class_name DeathManager

@export var root : Node

func die():
	print(root.name, " died. ")
	root.queue_free()


func _on_water_splash_manager_exited_water() -> void:
	die()
