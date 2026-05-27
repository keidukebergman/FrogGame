extends Node3D
class_name SlowMoManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_C):
		slow_time(0.2, 0.03)

func slow_time(to_amount:float, recovery_time:float):
	Engine.time_scale = 1 * to_amount;
	await get_tree().create_timer(recovery_time * Engine.time_scale).timeout
	while Engine.time_scale < 1:
		Engine.time_scale = move_toward(Engine.time_scale, 1, 0.01 + Engine.time_scale/10)
		await get_tree().create_timer(recovery_time * Engine.time_scale).timeout
