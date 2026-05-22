extends Node3D
class_name AggroManager

var notice_distance:float = 10
var player:Node3D = null
var target:Node3D = null
var target_request_cooldown = 0.3

signal requested_player_target(requester:AggroManager)

func _process(delta: float) -> void:
	target_request_cooldown = move_toward(target_request_cooldown, 0, delta)
	if player == null && target_request_cooldown <= 0:
		requested_player_target.emit(self as AggroManager)
		target_request_cooldown = randf_range(0.3, 5)
	if player != null && global_position.distance_to(player.global_position) < notice_distance:
		target = player

func receive_player_target(player_node:Node3D):
	player = player_node
