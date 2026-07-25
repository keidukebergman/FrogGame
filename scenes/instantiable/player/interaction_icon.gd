extends Sprite3D

@export var handler:InteractionHandler
@export var icon_animation_time:float = 0.3
@export var icon_animation_curve:Curve
var target_scale:Vector3
var timer:float = 0
var has_interactable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_scale = scale
	if handler:
		handler.found_interactable.connect(on_interactable_appeared)
		handler.lost_interactables.connect(on_interactable_disappeared)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dt = timer / icon_animation_time
	var s = icon_animation_curve.sample(dt)
	scale = lerp(Vector3.ZERO, target_scale, s);
	if has_interactable: timer += delta
	else: timer = 0

func on_interactable_appeared():
	scale = Vector3.ZERO
	timer = 0
	has_interactable = true
	

func on_interactable_disappeared():
	scale = Vector3.ZERO
	has_interactable = false
