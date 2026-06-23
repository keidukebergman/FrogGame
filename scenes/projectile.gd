extends RigidBody3D
class_name Projectile

@export var projectile_speed = 6
@export var projectile_damage = 20
@export var hitbox:Hitbox
@export var draggable_hurtbox: DraggableHurtbox
@export var is_draggable = true;
@export var is_parriable = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.start_detecting_hits()
	if hitbox:
		hitbox.hit_entity.connect(_on_hit_target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_set_velocity();


func _set_velocity():
	var basis = get_global_transform().basis
	var forward = basis.z
	linear_velocity = forward * projectile_speed


func _on_hit_target(hit_object:Node3D):
	var hurtbox = hit_object as Hurtbox
	if hurtbox == null:
		return;
	hurtbox.apply_damage(projectile_damage)
	queue_free()


func _on_parry():
	var basis = get_global_transform().basis
	var forward = basis.z
	linear_velocity = forward * projectile_speed
