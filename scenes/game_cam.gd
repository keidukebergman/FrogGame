extends Camera3D
class_name MainCamera

@export var offset:Vector3 = Vector3(0, 10.493, 12.335)
@export var target_position:Vector3 = Vector3(0, 10.493, 12.335)
@export var smoothing: float = 10

@export var min_coords:Vector2
@export var max_coords:Vector2 

@export var follow_target: bool = false
@export var target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#if follow_target:
		#target_position = target.global_position
		#var pos_xz = Vector3(target_position.x, 0, target_position.z)
		#target_position = pos_xz + offset;
		#global_position = pos_xz


func on_player_death():
	follow_target = true
