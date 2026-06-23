extends Node3D
class_name WaterSplashEffect


func do_splash() -> void:
	$AudioStreamPlayer3D.pitch_scale *= randf_range(0.8, 1.5)
	$AudioStreamPlayer3D.play()
	$Splash.emitting = true
	$Ring.emitting = true
	$SmallerRing.emitting = true
	$SmallererRing.emitting = true
	$Splash2.emitting = true
