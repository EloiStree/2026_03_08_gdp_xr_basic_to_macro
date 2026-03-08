
## Give signal event on script interacting enter exti
class_name MacroXrArrayNodeScriptsEnterExitGroupEvents
extends Node


## observing with update if one script of interaction is present
signal on_has_one_interactive_script_in_zone(has_one:bool)
## observing with update if one script of interaction is present
signal on_has_one_interactive_script_in_zone_started()
## observing with update if no script of interaction is present
signal on_has_one_interactive_script_in_zone_ended()

signal on_node_entered(node: Node)
signal on_node_exited(node: Node)

@export var interacting_list: Array[Node] 
@export var use_debug_prints: bool = false
@export var has_one = false


func add_node_to_dictionary(found:Array[Node]):
	for node in found:
		if node in interacting_list:
			continue
		interacting_list.append(node)
		if use_debug_prints:
			print("Valid node entered:", node)
		on_node_entered.emit(node)

	_check_for_one_node_state_changed()


func remove_node_from_dictionary(found:Array[Node]):
	for node in found:
		if node in interacting_list:
			interacting_list.erase(node)
			if use_debug_prints:
				print("Valid node exited:", node)
			on_node_exited.emit(node)
			
	_check_for_one_node_state_changed()

func _check_for_one_node_state_changed():
	var has_one_node := interacting_list.size()>0
	if has_one_node != has_one:
		has_one =has_one_node
		on_has_one_interactive_script_in_zone.emit(has_one)
		if has_one:
			on_has_one_interactive_script_in_zone_started.emit()
		else:
			on_has_one_interactive_script_in_zone_ended.emit()
