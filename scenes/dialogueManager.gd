extends Node
class_name DialogueManager

static var instance: DialogueManager #Is this cursed? Maybe not a singleton
var loreline: Loreline = Loreline.shared()

@export var dialogue_box:Control
@export var dialogue_text:Label

signal began_dialogue
signal finished_dialogue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	await get_tree().create_timer(5).timeout
	initiate_dialogue("res://story/loreline/_test/testDialogue.lor")

func initiate_dialogue(path:String) -> void:
	var script = await loreline.parse(path)
	if script == null:
		push_error("Failed to parse CoffeeShop.lor")
		return
	loreline.play(script, _on_dialogue, _on_choice, _on_finished)

func _handle_file(path: String, provide: Callable) -> void:
	if FileAccess.file_exists(path):
		var f := FileAccess.open(path, FileAccess.READ)
		provide.call(f.get_as_text())
	else:
		provide.call(null)

func _on_dialogue(interp: LorelineInterpreter, character: String, text: String, tags: Array, advance: Callable) -> void:
	if character != "":
		var display_name: String = interp.get_character_field(character, "name")
		if display_name != "":
			character = display_name
		print(character + ": " + text)
	else:
		print(text)
	await get_tree().create_timer(1.5).timeout
	advance.call()

func _on_choice(_interp: LorelineInterpreter, options: Array, select: Callable) -> void:
	var enabled_indices: Array[int] = []
	for i in range(options.size()):
		if options[i]["enabled"]:
			enabled_indices.append(i)
			print("  [" + str(enabled_indices.size()) + "] " + options[i]["text"])

	# In a real project, wait for player input here.
	# For this example, automatically select the first enabled choice:
	select.call(enabled_indices[0])

func _on_finished(_interp: LorelineInterpreter) -> void:
	print("--- The End ---")
