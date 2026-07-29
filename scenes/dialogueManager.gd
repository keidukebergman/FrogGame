extends Node
class_name DialogueManager

static var instance: DialogueManager #Is this cursed? Maybe not a singleton
var loreline: Loreline = Loreline.shared()
var buttons:Array[Button] = []
var button_connections: Array[Callable] = []
var in_dialogue:bool = false

@export var dialogue_box:Control
@export var dialogue_text:Label
@export var dialogue_button:Button

var current_text = ""
var counting_up_text:bool = false
var current_text_timer:float = 0
signal next_character

var counting_up_transition:bool = false
var current_transition_timer:float = 0
signal next_transition

signal advance_dialogue_clicked

signal began_dialogue
signal finished_dialogue
signal began_animation_event
signal ended_animation_event



var options:LorelineOptions 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	dialogue_button.visible = false
	set_ui_visibility(false)
	options = LorelineOptions.new()
	options.set_async_function("animation_event", _on_animation_event)

func _process(delta:float) -> void:
	var timer_coefficient = 1

	if (Input.is_action_pressed("advance dialogue")):
		timer_coefficient = 0.1
	
	if counting_up_text:
		current_text_timer += delta
		if current_text_timer > 0.05 * timer_coefficient:
			current_text_timer = 0
			next_character.emit()

	if counting_up_transition:
		current_transition_timer += delta
		if current_transition_timer > 0.4 * timer_coefficient:
			current_transition_timer = 0
			next_transition.emit()

	if (Input.is_action_just_pressed("advance dialogue")):
		advance_dialogue_clicked.emit()


func initiate_dialogue(path:String, beat:String) -> void:
	if in_dialogue: return
	print("Tried to iniate dialogue at ", path)
	in_dialogue = true
	var script = await loreline.parse(path)
	if script == null:
		push_error("Failed to parse .lor file")
		return
	loreline.play(script, _on_dialogue, _on_choice, _on_finished, "", options)
	set_ui_visibility(true)
	began_dialogue.emit()
	print("Dialogue Initiated")

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
	counting_up_transition = true
	await next_transition
	counting_up_transition = false
	counting_up_text = true
	for letter in text:
		dialogue_text.text = output_text
		output_text += letter    
		await next_character
	counting_up_text = false
	dialogue_text.text = output_text
	await advance_dialogue_clicked
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

func _on_animation_event(interp: LorelineInterpreter, _args: Array, resolve: Callable) -> void:
	var time = _args[0]
	set_ui_visibility(false)
	print("TIMER IS CREATE!")
	await get_tree().create_timer(time).timeout
	print("TIME IS DONE!")
	set_ui_visibility(true)
	resolve.call()

func _on_finished(_interp: LorelineInterpreter) -> void:
	print("--- The End ---")
	finished_dialogue.emit()
	set_ui_visibility(false)

func set_ui_visibility(value:bool) -> void:
	dialogue_box.visible = value
	dialogue_text.visible = value
	in_dialogue = value
	if value == false:
		dialogue_text.text = ""
