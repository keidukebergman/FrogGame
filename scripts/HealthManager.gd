extends Node3D

@export var max_health = 30;
var current_health = 30;
var has_signaled_death = false;

signal died

func apply_damage (damage):
	current_health -= damage;
	if current_health < 0:
		current_health = 0;

func set_health(health):
	current_health = health

func heal (amount):
	current_health += amount

func _process(_delta):
	if current_health == 0 and has_signaled_death == false:
		has_signaled_death = true
		died.emit()
