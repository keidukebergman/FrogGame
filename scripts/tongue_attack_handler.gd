extends Node3D
class_name TongueAttackManager

var usable:bool = true
var tongue_state:TongueState = TongueState.WAITING
var attached_is_heavy:bool = false
var tongue_attached_node:Node3D = null
var tongue_attached_node_offset:Vector3
var tongue_target_position:Vector3
@export var attach_force:float = 10
@export var mouth_marker:Node3D
@export var tongue_hitbox:Hitbox
@export var max_length:float = 1
@export var extension_speed:float = 10
@export var retraction_speed:float = 7
@export var retraction_acceleration_speed:float = 1
@export var fall_to_floor_speed:float = 0.5
@export var tongue_tip_node:Node3D
@export var tongue_line_node:Sprite3D
@export var state_manager:FrogStateMachine
@export var state_machine_state:PlayerTongueAttackState
var retraction_acceleration_counter = 0

enum TongueState {
	WAITING,
	EXTENDING,
	RETRACTING,
	FALLING,
	ATTACHED
}

signal attached(target:Node3D, offset:Vector3, heavy:bool)

func attached_object_destroyed() -> void:
	_start_retracting()

func _tongue_hit_object(body:Node3D) -> void:
	if !usable:
		return
	tongue_state = TongueState.ATTACHED
	attached_is_heavy = true
	tongue_attached_node_offset = body.global_position - tongue_tip_node.global_position
	if body is DraggableHurtbox:
		attached_is_heavy = body.is_heavy
		tongue_attached_node_offset = Vector3.ZERO
	tongue_attached_node = body
	if tongue_attached_node != null && tongue_attached_node is DraggableHurtbox && tongue_attached_node.is_heavy == false:
		tongue_attached_node.start_dragging(self)
	elif tongue_attached_node != null:
		state_manager._change_state(state_machine_state)
	
	
func _ready() -> void:
	tongue_hitbox.hit_entity.connect(_tongue_hit_object)

func _process(delta: float) -> void:
	var target_pos = tongue_tip_node.global_position
	var start_pos = mouth_marker.global_position
	var dir = target_pos - start_pos
	var dist = dir.length()
	
#TODO: Put this in separate function
	if dist > 0.01: 
		tongue_line_node.visible = true 
		tongue_line_node.global_position = start_pos + (dir / 2.0)
		tongue_line_node.look_at(target_pos, Vector3.UP)
		tongue_line_node.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
		tongue_line_node.scale.y = dist * 5.0
	else:
		tongue_line_node.visible = false 
		tongue_line_node.scale.y = 0.001
	
	if not usable:
		_start_retracting()
	match tongue_state:
		TongueState.WAITING:
			tongue_tip_node.visible = false
			tongue_line_node.visible = false
			if Input.is_action_just_pressed("tongue_attack"):
				tongue_attack_raycast()
		TongueState.EXTENDING:
			_test_for_retracting()
			tongue_tip_node.position = tongue_tip_node.position.move_toward(tongue_target_position, delta*extension_speed)
			if dist > 0.1 && !tongue_hitbox.is_active:
				tongue_hitbox.is_active = true
				tongue_hitbox.start_detecting_hits()
			if tongue_tip_node.position.distance_to(tongue_target_position) < 0.01:
				_start_retracting()
		TongueState.RETRACTING:
			if tongue_tip_node.position.distance_to(mouth_marker.global_position) < 0.1:
				tongue_state = TongueState.WAITING
				tongue_tip_node.reparent(self)
				retraction_acceleration_counter = 0
			else:
				retraction_acceleration_counter += delta
				tongue_tip_node.position = tongue_tip_node.position.move_toward(mouth_marker.global_position, delta*(retraction_speed+retraction_acceleration_counter)) 
		TongueState.ATTACHED:
			_test_for_retracting()
			if tongue_attached_node == null:
				_start_retracting()
			tongue_tip_node.global_position = tongue_attached_node.global_position + tongue_attached_node_offset

func _test_for_retracting():
	if Input.is_action_just_released("tongue_attack"):
		_start_retracting()

func _start_retracting():
	if tongue_attached_node != null && tongue_attached_node is DraggableHurtbox:
		tongue_attached_node.stop_dragging()
	tongue_state = TongueState.RETRACTING
	tongue_hitbox.is_active = false
	tongue_hitbox.stop_detecting_hits()
	state_machine_state.end_attachment()

func get_direction_to_attached(origin:Node3D) -> Vector3:
	return (tongue_attached_node.global_position + tongue_attached_node_offset - origin.position).normalized()

func get_attached_body() -> Node3D:
	return tongue_attached_node

func tongue_attack_raycast():
	var inputvector:Vector2 = InputReader._get_attack_offset(self).normalized()
	var target_point:Vector3 = self.global_position + Vector3(-inputvector.x, 0, -inputvector.y) * 5
	target_point.y = self.global_position.y
	tongue_state = TongueState.EXTENDING
	tongue_tip_node.reparent(get_tree().get_root())
	tongue_tip_node.visible = true
	tongue_line_node.visible = true
	tongue_target_position = target_point
	#var cam = get_viewport().get_camera_3d()
	#var ray_origin = InputReader.get_mouse_world_origin(cam)
	#var ray_normal = InputReader.get_mouse_world_normal(cam)
	#var space_state = get_world_3d().direct_space_state
	#var ray_end = ray_origin + ray_normal * 100
	#var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	#query.collide_with_areas = true
	#query.collide_with_bodies = true
	#var result = space_state.intersect_ray(query)
	#if result != null and result.has("position"):
		#var target_point:Vector3 = result.position
		#target_point.y = self.position.y
		#tongue_target_position = target_point
		#tongue_state = TongueState.EXTENDING
		#tongue_hitbox.is_active = true
		#tongue_tip_node.reparent(get_tree().get_root())
		#tongue_hitbox.start_detecting_hits()
		#tongue_tip_node.visible = true
		#tongue_line_node.visible = true
