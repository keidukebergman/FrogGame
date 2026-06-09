extends Control
class_name HealthBarManager

var health_maximum:float
var health_actual:float
var health_display:float
@export var health_interpolation_speed:float = 30

var damage_actual:float
var damage_display:float
@export var damage_interpolation_speed:float = 30
@export var damage_interpolation_wait:float = 0.3


@export var damage_bar:ProgressBar
@export var health_bar:ProgressBar

# Called when thh node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_display = move_toward(health_display, health_actual, health_interpolation_speed*delta)
	damage_display = move_toward(damage_display, damage_actual, damage_interpolation_speed*delta)
	health_bar.value = health_display
	damage_bar.value = damage_display

func on_health_changed(damaged, current_health):
	health_actual = current_health
	if damaged:
		await get_tree().create_timer(damage_interpolation_wait).timeout
	damage_actual = current_health
