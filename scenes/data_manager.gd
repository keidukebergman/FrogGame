extends Node3D

@export var save: GameSaveData = GameSaveData.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save.load_file("main")
	print(save.save_dict)
	save.save_to_file()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
