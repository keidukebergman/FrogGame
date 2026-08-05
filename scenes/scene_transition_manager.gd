class_name SceneTransition extends Node

var position:float = -1.0
var direction:float = 1
var left_right:bool = false
var target_position:float = 1
var transition_speed:float = 1
@export var color_rect:ColorRect
var has_reached_position = true
signal finished_transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_reached_position == false:
		position = move_toward(position, target_position, delta * transition_speed)
		color_rect.material.set_shader_parameter("position", position)
		if position == target_position:
			has_reached_position = true
			finished_transition.emit()

func do_screen_wipe(pos, lr, target_pos, speed_tr):
	color_rect.material.set_shader_parameter("left_right", lr)
	position = pos
	target_position = target_pos
	transition_speed = speed_tr
	has_reached_position = false

func request_screen_wipe(dir:int, phase:int):
	match dir:
		0: 
			if phase == 0: do_screen_wipe(-5, false, 0.5, 5) 
			else: do_screen_wipe(0.5, false, 5, 5)
		3:
			if phase == 0: do_screen_wipe(5, false, 0.5, 5) 
			else: do_screen_wipe(0.5, false, -5, 5)
		1:
			if phase == 0: do_screen_wipe(-3, true, 0.5, 5) 
			else: do_screen_wipe(0.5, true, 3, 5)
		2:
			if phase == 0: do_screen_wipe(3, false, 0.5, 5) 
			else: do_screen_wipe(0.5, false, 3, 5)
