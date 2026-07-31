extends Control
class_name StaminaMarkerManager

@export var node_list:Array[ColorRect]
@export var inactive_color:Color
@export var active_color:Color

var active_nodes:int
var fraction_node:float

func update_stamina(int_part, frac_part):
	active_nodes = int_part
	fraction_node = frac_part
	var n = 0
	for node in node_list:
		node.color = active_color if n < active_nodes else inactive_color
		n += 1
