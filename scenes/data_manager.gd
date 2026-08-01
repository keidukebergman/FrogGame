class_name DataManager extends Node3D

@export var save: GameSaveData = GameSaveData.new()

# Called when the node enters the scene tree for the first time.
func load_data() -> void:
	save.load_file("main")

func get_save_parameter(key:String):
	if save.save_dict.has(key):
		return save.save_dict.get(key)
	return null

func set_save_parameter(key:String, value:Variant):
	save.save_dict.set(key, value)

func save_data() -> void:
	save.save_to_file()
