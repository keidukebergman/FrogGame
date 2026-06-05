extends Node3D
class_name CameraShakeManager

@export var camera_main:Camera3D

func start_shake_effect(bounces: int, bounce_distance: float, direction: Vector3):
	var origin = camera_main.position
	var tween = create_tween()
	tween.tween_property(
		camera_main,
		"position",
		Vector3(origin.x + bounce_distance * direction.x, origin.y, origin.z + bounce_distance * direction.z),
		0.01
	)
	await tween.finished
	var return_tween = create_tween()
	return_tween.tween_property(camera_main, "position", origin, 0.05)
	await return_tween.finished
