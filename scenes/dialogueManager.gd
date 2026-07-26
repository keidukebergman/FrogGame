extends Node
class_name DialogueManager

static var instance: DialogueManager #Is this cursed? Maybe not a singleton
var loreline: Loreline = Loreline.shared()
var buttons:Array[Button] = []
var button_connections: Array[Callable] = []

@export var dialogue_box:Control
@export var dialogue_text:Label
@export var dialogue_button:Button

var current_text = ""

signal began_dialogue
signal finished_dialogue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	dialogue_box.visible = false
	dialogue_text.visible = false
	dialogue_button.visible = false

func initiate_dialogue(path:String) -> void:
	var script = await loreline.parse(path)
	if script == null:
		push_error("Failed to parse .lor file")
		return
	loreline.play(script, _on_dialogue, _on_choice, _on_finished)
	dialogue_box.visible = true
	dialogue_text.visible = true

func _handle_file(path: String, provide: Callable) -> void:
	if FileAccess.file_exists(path):
		var f := FileAccess.open(path, FileAccess.READ)
		provide.call(f.get_as_text())
	else:
		provide.call(null)

func _on_dialogue(interp: LorelineInterpreter, character: String, text: String, tags: Array, advance: Callable) -> void:
	var output_text = ""
	if character != "":
		var display_name: String = interp.get_character_field(character, "name")
		if display_name != "":
			character = display_name
			output_text = character + ": "
	dialogue_text.text = output_text
	await get_tree().create_timer(0.4).timeout
	for letter in text:
		dialogue_text.text = output_text
		output_text += letter    
		await get_tree().create_timer(0.05).timeout
	dialogue_text.text = output_text
	await get_tree().create_timer(0.9).timeout
	advance.call()

var current_select = null
var enabled_indices:Array[int]

func _on_choice(_interp: LorelineInterpreter, options: Array, select: Callable) -> void:
	dialogue_button.visible = true
	enabled_indices = []
	buttons = []
	button_connections = []
	for i in range(options.size()):
		if options[i]["enabled"]:
			var button: Button = dialogue_button
			if enabled_indices.size() != 0:
				var new_button = button.duplicate()
				button.get_parent().add_child(new_button)
				button = new_button
			buttons.append(button)
			enabled_indices.append(i)
			button.text = options[i]["text"]
			var bound_callable := _choice_callback.bind(i)
			button_connections.append(bound_callable)
			button.button_down.connect(bound_callable)

			print("  [" + str(enabled_indices.size()) + "] " + options[i]["text"])
	current_select = select

func _choice_callback(index) -> void:
	if current_select != null:
		current_select.call(enabled_indices[index])
		current_select = null
	for i in range(buttons.size()):
		if is_instance_valid(buttons[i]):
			buttons[i].button_down.disconnect(button_connections[i])
	for button in buttons:
		if button != dialogue_button:
			button.queue_free()
	buttons = []
	button_connections = []
	dialogue_button.visible = false

func _on_finished(_interp: LorelineInterpreter) -> void:
	print("--- The End ---")
	dialogue_box.visible = false
	dialogue_text.visible = false
