extends Node
class_name PlayerAttack

@export_group("Attack Properties")
@export var damage:float = 10
@export var knockback_amount:float = 5.0
@export var attack_knockback_force = 5

@export_group("Movement And Forces")
@export var slice_movement_force:float = 4
@export var slice_movement_curve:Curve
@export var attack_deceleration:float = 10
@export var bounce_deceleration:float = 5
@export var can_take_attack_knockback = true

@export_group("Timing")
@export var attack_time:float = 0.5
@export var attack_windup_time:float = 0.2

@export_group("References")
@export var slash_hitbox:Hitbox
@export var slash_fx:Node3D
