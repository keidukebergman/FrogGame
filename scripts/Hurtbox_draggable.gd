extends Hurtbox
class_name DraggableHurtbox

@export var is_heavy: bool = false
enum DraggableType {
	LIGHT,
	HEAVY
}
signal started_being_dragged(dragger, drag_point, force) 
signal stopped_being_dragged

func _ready() -> void:
	super._ready()
	
func verify_hit() -> bool:
	return super.verify_hit()
	
func apply_damage(damage) -> void:
	super.apply_damage(damage)

func start_dragging(dragger, drag_point, force) -> void:
	started_being_dragged.emit(dragger, drag_point, force)
	print(name, ": being dragged")

func stop_dragging() -> void:
	stopped_being_dragged.emit()
	print(name, ": stopped being dragged")
