class_name SceneManager extends Node

var current_level:Node

signal requested_level_switch
signal started_loading_level
signal finished_loading_level

func request_level_switch(level:PackedScene):
	requested_level_switch.emit(level)

func switch_level(level:PackedScene) -> Level.LevelType:
	started_loading_level.emit()
	if current_level:
		current_level.queue_free()
	current_level = level.instantiate()
	add_child(current_level)
	finished_loading_level.emit()
	return (current_level as Level).
