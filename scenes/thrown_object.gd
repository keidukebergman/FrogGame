extends Node3D
class_name ThrownObject

@export var hitbox:Hitbox
var hit_objects:Array = []

func _ready() -> void:
	hitbox.hit_entity.connect(on_hitbox_hit_object)

func calculate_damage() -> float:
	return 100

func on_hitbox_hit_object(node) -> void:
	print("HIT:", node)

func on_start_moving() -> void:
	hitbox.start_detecting_hits()

func on_stop_moving() -> void:
	hitbox.stop_detecting_hits()
	hit_objects = []
