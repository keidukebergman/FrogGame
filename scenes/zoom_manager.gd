extends Node3D
class_name ZoomInManager

var standard_zoom:float
var zoom_state : ZoomState
var target_zoom:float
var zoom_in_speed:float
var zoom_out_speed:float
@export var camera:Camera3D

enum ZoomState {
	STANDBY,
	ZOOMING_IN,
	ZOOMING_OUT
}

func _ready() -> void:
	standard_zoom = camera.size

func _process(delta: float) -> void:
	if zoom_state == ZoomState.ZOOMING_IN:
		camera.size = move_toward(camera.size, target_zoom, delta*zoom_in_speed)
		if abs(camera.size-target_zoom) < 0.01:
			zoom_state = ZoomState.ZOOMING_OUT
	elif zoom_state == ZoomState.ZOOMING_OUT:
		camera.size = move_toward(camera.size, standard_zoom, delta*zoom_out_speed)
		if abs(camera.size-standard_zoom) < 0.01:
			zoom_state = ZoomState.STANDBY

func start_zoom_effect(zoom_factor:float, zoom_in_speed_t:float, zoom_out_speed_t:float):
	zoom_state = ZoomState.ZOOMING_IN
	self.zoom_in_speed = zoom_in_speed_t
	self.zoom_out_speed = zoom_out_speed_t
	target_zoom = zoom_factor * standard_zoom
