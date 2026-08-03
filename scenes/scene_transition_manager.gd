extends Node

var position:float = -1.0
var direction:float = 1
var left_right:bool = false
var target_position:float = 1
var transition_speed:float = 1
@export var color_rect:ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_screen_wipe(-1, true, 0.5, 1)
	await get_tree().create_timer(3).timeout
	do_screen_wipe(0.5, true, 1.5, 1)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = move_toward(position, target_position, delta * transition_speed)
	color_rect.material.set_shader_parameter("position", position)

func do_screen_wipe(pos, lr, target_pos, speed_tr):
	color_rect.material.set_shader_parameter("left_right", lr)
	position = pos
	target_position = target_pos
	transition_speed = speed_tr
