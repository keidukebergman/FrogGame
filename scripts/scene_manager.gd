class_name SceneManager extends Node

var current_level:Node
@export var level_dictionary : Dictionary[String, PackedScene]

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
	return (current_level as Level).level_type

func async_switch_level(level_path:String) -> Level.LevelType:
	started_loading_level.emit()
	var err := ResourceLoader.load_threaded_request(level_path)
	if err != OK:
		push_error("Failed to start loading: %s" % level_path)
		return Level.LevelType.None
	while true:
		var status = ResourceLoader.load_threaded_get_status(level_path, [])
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await get_tree().process_frame
			ResourceLoader.THREAD_LOAD_LOADED:
				break
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				push_error("Level failed to load: %s" % level_path)
				return Level.LevelType.None
	var level_scene: PackedScene = ResourceLoader.load_threaded_get(level_path)
	
	if level_scene is not PackedScene:
		push_error("Path was not PackedScene")
		return Level.LevelType.None
		
	if current_level:
		current_level.queue_free()
		await get_tree().process_frame
	current_level = level_scene.instantiate()
	add_child(current_level)
	finished_loading_level.emit()
	return (current_level as Level).level_type
