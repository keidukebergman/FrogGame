class_name EnemyStaggerHandler extends Node3D

@export var body:PhysicsBody3D

signal was_staggered (force:int)

var is_active = false

func _ready() -> void:
	get_parent().took_stagger.connect(on_take_stagger)

func on_take_stagger (force:int) -> void:
	if is_active:
		was_staggered.emit(force)
