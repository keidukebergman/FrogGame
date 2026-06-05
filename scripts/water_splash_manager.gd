extends Node3D
class_name WaterSplashHandler

@export var hurtbox:Hurtbox
@export var splash_effect_enter:PackedScene
@export var splash_effect_exit:PackedScene

signal entered_water
signal exited_water

func _ready() -> void:
	hurtbox.area_entered.connect(on_water_entered)
	hurtbox.area_exited.connect(on_water_exited)

func on_water_entered(body:Area3D):
	if body.collision_layer == 4:
		print("ENTERED WATER")
		var splash:WaterSplashEffect = splash_effect_enter.instantiate()
		get_tree().root.add_child(splash)
		splash.global_position = self.global_position
		splash.do_splash()
		entered_water.emit()
	pass

func on_water_exited(body:Area3D):
	if body.collision_layer == 4:
		print("EXITED WATER")
		exited_water.emit()
	pass
